#!/usr/bin/env bash
# Empty an OCI compartment so it can be deleted.
#
# "Compartment Not Empty" means the compartment still has resources, child
# compartments, IAM policies, or keys/vaults inside a deletion waiting period.
# Resources are regional: this script checks every subscribed region.
#
# Authentication is the OCI CLI itself (https://docs.oracle.com/iaas/Content/API/SDKDocs/cliconfigure.htm):
#   ~/.oci/config from `oci setup config`, plus the same global options as `oci`:
#   --config-file, --profile, --auth, and OCI_CLI_CONFIG_FILE / OCI_CLI_PROFILE / OCI_CLI_AUTH.
#   --auth: api_key (default), security_token, instance_principal, resource_principal, instance_obo_user.
#
# Dry-run (default):
#   ./scripts/oci-clean.sh --profile DEFAULT --auth api_key \
#     --compartment-id ocid1.compartment.oc1..example
#
# Delete resources and child compartments:
#   ./scripts/oci-clean.sh --profile DEFAULT --auth api_key \
#     --compartment-id ocid1.compartment.oc1..example --apply
#
# Also delete the compartment itself:
#   ./scripts/oci-clean.sh --profile DEFAULT --auth api_key \
#     --compartment-id ocid1.compartment.oc1..example --apply --delete-compartment --yes
#
# Requires: oci, jq. Refuses the tenancy root compartment.
# shellcheck shell=bash

set -euo pipefail

APPLY=0
DELETE_COMPARTMENT=0
YES=0
MAX_PASSES=5
COMPARTMENT_ID=""
REGION_ARGS=""

usage() {
  cat <<'EOF'
Empty an OCI compartment so it can be deleted.

Authentication matches the oci CLI. Create ~/.oci/config with `oci setup config`,
then pass the same global options (or export OCI_CLI_CONFIG_FILE, OCI_CLI_PROFILE, OCI_CLI_AUTH):

  --config-file PATH
  --profile NAME
  --auth api_key|security_token|instance_principal|resource_principal|instance_obo_user

  ./scripts/oci-clean.sh --profile DEFAULT --auth api_key \
    --compartment-id ocid1.compartment.oc1..example
  ./scripts/oci-clean.sh --profile DEFAULT --auth api_key \
    --compartment-id ocid1.compartment.oc1..example --apply --delete-compartment --yes

Check the same credentials first:
  oci iam region list --profile DEFAULT --auth api_key
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --compartment-id)
      COMPARTMENT_ID="${2:-}"
      shift 2
      ;;
    --region)
      REGION_ARGS="${REGION_ARGS} ${2:-}"
      shift 2
      ;;
    --apply) APPLY=1; shift ;;
    --delete-compartment) DELETE_COMPARTMENT=1; shift ;;
    --yes) YES=1; shift ;;
    --max-passes)
      MAX_PASSES="${2:-}"
      shift 2
      ;;
    -h|--help) usage; exit 0 ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [[ -z "$COMPARTMENT_ID" ]]; then
  usage >&2
  exit 2
fi
if ! [[ "$COMPARTMENT_ID" =~ ^ocid1\.(compartment|tenancy)\.oc1\. ]]; then
  echo "compartment-id must be an OCID (ocid1.compartment.oc1...)." >&2
  exit 2
fi
if ! [[ "$MAX_PASSES" =~ ^[1-9][0-9]*$ ]]; then
  echo "--max-passes must be a positive integer." >&2
  exit 2
fi
command -v oci >/dev/null 2>&1 || { echo "oci CLI not found. Install it and run 'oci setup config'." >&2; exit 1; }
command -v jq >/dev/null 2>&1 || { echo "jq is required." >&2; exit 1; }

export OCI_CLI_SUPPRESS_FILE_PERMISSIONS_WARNING=True

TMPDIR_CLEAN=$(mktemp -d "${TMPDIR:-/tmp}/oci-clean.XXXXXX")
trap 'rm -rf "$TMPDIR_CLEAN"' EXIT

HOME_REGION=""
TENANCY_ID=""
OS_NAMESPACE=""
TARGET_NAME=""

log() { printf '%s\n' "$*"; }

oci_try() {
  if [[ "$APPLY" -eq 1 ]]; then
    log "+ oci $*"
    if ! oci "$@"; then
      log "FAILED: oci $*" >&2
      return 1
    fi
  else
    log "dry-run: oci $*"
  fi
}

deletion_time() {
  if date -u -v+30d +%Y-%m-%dT%H:%M:%SZ >/dev/null 2>&1; then
    date -u -v+30d +%Y-%m-%dT%H:%M:%SZ
  else
    date -u -d '+30 days' +%Y-%m-%dT%H:%M:%SZ
  fi
}

priority_for() {
  case "$1" in
    VolumeAttachment|BootVolumeAttachment|VnicAttachment|BastionSession|Export) echo 10 ;;
    Policy|Quota|TagDefault|Budget|EventRule|Rule|ServiceConnector|OrmStack|Stack) echo 15 ;;
    Instance|InstancePool|DbSystem|MysqlDbSystem|AutonomousDatabase|PostgresqlDbSystem|NosqlTable|NodePool|ContainerInstance|FunctionsFunction|Deployment|ApiDeployment|LoadBalancer|NetworkLoadBalancer|NetworkFirewall|Alarm|OnsSubscription|Subscription|Sender|EmailSender|Certificate|Secret|VaultSecret|Log|CloudVmCluster|VirtualCircuit|DrProtectionGroup|GenerativeAiEndpoint|DedicatedAiCluster|DataSafeTargetDatabase|SecurityZone|CloudGuardTarget) echo 20 ;;
    Cluster|FunctionsApplication|ApiGateway|Gateway|Bastion|LogGroup|OnsTopic|NotificationTopic|MountTarget|FileSystem|AnalyticsInstance|IntegrationInstance|GoldenGateDeployment|ApmDomain|RedisCluster|OciCacheCluster|OpensearchCluster|WebAppFirewall|WafPolicy|NetworkFirewallPolicy|DataSafePrivateEndpoint|SecurityRecipe|CrossConnect) echo 30 ;;
    Subnet|Vlan) echo 40 ;;
    NatGateway|InternetGateway|ServiceGateway|LocalPeeringGateway|DrgAttachment|RemotePeeringConnection|IPSecConnection|Cpe|RouteTable|SecurityList|NetworkSecurityGroup|DhcpOptions|PublicIp|Ipv6|Vtap|CaptureFilter|CrossConnectGroup) echo 50 ;;
    Volume|BootVolume|VolumeBackup|BootVolumeBackup|VolumeGroup|Image|VolumeGroupBackup) echo 60 ;;
    Vcn|Drg|CloudExadataInfrastructure) echo 70 ;;
    Key) echo 80 ;;
    Vault|CertificateAuthority) echo 90 ;;
    *) echo 100 ;;
  esac
}

# Skip resources that are already going away. PENDING_DELETION still blocks the
# compartment until Oracle finishes the waiting period; those are reported later.
is_busy_state() {
  case "$1" in
    DELETED|TERMINATED|TERMINATING|DELETING|PENDING_DELETION|SCHEDULING_DELETION|DELETED_SCHEDULED) return 0 ;;
    *) return 1 ;;
  esac
}

reset_pass_files() {
  : > "$TMPDIR_CLEAN/ids"
  : > "$TMPDIR_CLEAN/resources.tsv"
}

add_resource() {
  local pri="$1" region="$2" type="$3" id="$4" name="$5" state="${6:-}"
  [[ -z "$id" || "$id" == "null" ]] && return 0
  if is_busy_state "$state"; then
    printf '%s\t%s\t%s\t%s\n' "$region" "$type" "$id" "$state" >> "$TMPDIR_CLEAN/waiting.all"
    return 0
  fi
  local key="${region}:${id}"
  if grep -Fqx "$key" "$TMPDIR_CLEAN/ids"; then
    return 0
  fi
  printf '%s\n' "$key" >> "$TMPDIR_CLEAN/ids"
  name=${name//$'\t'/ }
  name=${name//$'\n'/ }
  printf '%s\t%s\t%s\t%s\t%s\n' "$pri" "$region" "$type" "$id" "$name" >> "$TMPDIR_CLEAN/resources.tsv"
}

json_or_empty() {
  oci "$@" --output json 2>"$TMPDIR_CLEAN/oci.err" || {
    log "warn: oci $* failed: $(tr '\n' ' ' < "$TMPDIR_CLEAN/oci.err")" >&2
    echo '{"data":[]}'
    return 0
  }
}

collect_search() {
  local region="$1" cid="$2" json type id name state pri
  json=$(json_or_empty --region "$region" search resource structured-search \
    --query-text "query all resources where compartmentId = '${cid}'" \
    --limit 1000 --all) || true
  echo "$json" | jq -c '.data.items[]? // .data[]? // empty' 2>/dev/null | while IFS= read -r row; do
    type=$(echo "$row" | jq -r '.["resource-type"] // empty')
    id=$(echo "$row" | jq -r '.identifier // empty')
    name=$(echo "$row" | jq -r '.["display-name"] // empty')
    state=$(echo "$row" | jq -r '.["lifecycle-state"] // empty')
    case "$type" in
      Compartment|Bucket|Log|LogGroup|Key|Vault|KmsKey|KmsVault) continue ;;
    esac
    pri=$(priority_for "$type")
    add_resource "$pri" "$region" "$type" "$id" "$name" "$state"
  done
}

collect_policies() {
  local cid="$1" json id name state
  json=$(json_or_empty iam policy list --region "$HOME_REGION" --compartment-id "$cid" --all)
  echo "$json" | jq -c '.data[]?' | while IFS= read -r row; do
    id=$(echo "$row" | jq -r '.id // empty')
    name=$(echo "$row" | jq -r '.name // empty')
    state=$(echo "$row" | jq -r '.["lifecycle-state"] // empty')
    add_resource 15 "$HOME_REGION" Policy "$id" "$name" "$state"
  done
}

collect_quotas() {
  local cid="$1" json id name state
  json=$(json_or_empty limits quota list --region "$HOME_REGION" --compartment-id "$cid" --all)
  echo "$json" | jq -c '.data[]?' | while IFS= read -r row; do
    id=$(echo "$row" | jq -r '.id // empty')
    name=$(echo "$row" | jq -r '.name // empty')
    state=$(echo "$row" | jq -r '.["lifecycle-state"] // empty')
    add_resource 15 "$HOME_REGION" Quota "$id" "$name" "$state"
  done
}

collect_tag_defaults() {
  local cid="$1" json id
  json=$(json_or_empty iam tag-default list --region "$HOME_REGION" --compartment-id "$cid" --all)
  echo "$json" | jq -c '.data[]?' | while IFS= read -r row; do
    id=$(echo "$row" | jq -r '.id // empty')
    add_resource 15 "$HOME_REGION" TagDefault "$id" "tag-default" "ACTIVE"
  done
}

collect_buckets() {
  local region="$1" cid="$2" json name
  [[ -z "$OS_NAMESPACE" ]] && return 0
  json=$(json_or_empty --region "$region" os bucket list --compartment-id "$cid" --namespace-name "$OS_NAMESPACE" --all)
  echo "$json" | jq -c '.data[]?' | while IFS= read -r row; do
    name=$(echo "$row" | jq -r '.name // empty')
    [[ -z "$name" ]] && continue
    # Bucket OCID is not required; delete uses the name. Use name as the id key.
    add_resource 20 "$region" Bucket "$name" "$name" "ACTIVE"
  done
}

collect_logs() {
  local region="$1" cid="$2" groups gid gname logs lid lname
  groups=$(json_or_empty --region "$region" logging log-group list --compartment-id "$cid" --all)
  echo "$groups" | jq -c '.data[]?' | while IFS= read -r grow; do
    gid=$(echo "$grow" | jq -r '.id // empty')
    gname=$(echo "$grow" | jq -r '.["display-name"] // empty')
    logs=$(json_or_empty --region "$region" logging log list --log-group-id "$gid" --all)
    echo "$logs" | jq -c '.data[]?' | while IFS= read -r lrow; do
      lid=$(echo "$lrow" | jq -r '.id // empty')
      lname=$(echo "$lrow" | jq -r '.["display-name"] // empty')
      add_resource 20 "$region" "Log:${gid}" "$lid" "$lname" "$(echo "$lrow" | jq -r '.["lifecycle-state"] // empty')"
    done
    add_resource 30 "$region" LogGroup "$gid" "$gname" "$(echo "$grow" | jq -r '.["lifecycle-state"] // empty')"
  done
}

collect_kms() {
  local region="$1" cid="$2" vaults vid vname endpoint keys kid kname kstate when
  vaults=$(json_or_empty --region "$region" kms management vault list --compartment-id "$cid" --all)
  echo "$vaults" | jq -c '.data[]?' | while IFS= read -r vrow; do
    vid=$(echo "$vrow" | jq -r '.id // empty')
    vname=$(echo "$vrow" | jq -r '.["display-name"] // empty')
    endpoint=$(echo "$vrow" | jq -r '.["management-endpoint"] // empty')
    vstate=$(echo "$vrow" | jq -r '.["lifecycle-state"] // empty')
    if [[ -n "$endpoint" ]]; then
      keys=$(json_or_empty --region "$region" kms management key list --compartment-id "$cid" --endpoint "$endpoint" --all)
      echo "$keys" | jq -c '.data[]?' | while IFS= read -r krow; do
        kid=$(echo "$krow" | jq -r '.id // empty')
        kname=$(echo "$krow" | jq -r '.["display-name"] // empty')
        kstate=$(echo "$krow" | jq -r '.["lifecycle-state"] // empty')
        add_resource 80 "$region" "Key:${endpoint}" "$kid" "$kname" "$kstate"
      done
    fi
    add_resource 90 "$region" Vault "$vid" "$vname" "$vstate"
  done
}

empty_bucket() {
  local region="$1" name="$2" pars pid versions ver_id obj
  [[ -z "$OS_NAMESPACE" ]] && return 0
  oci_try --region "$region" os object bulk-delete \
    --namespace-name "$OS_NAMESPACE" --bucket-name "$name" --force || true
  pars=$(json_or_empty --region "$region" os preauth-request list \
    --namespace-name "$OS_NAMESPACE" --bucket-name "$name" --all)
  echo "$pars" | jq -r '.data[]?.id // empty' | while IFS= read -r pid; do
    [[ -z "$pid" ]] && continue
    oci_try --region "$region" os preauth-request delete \
      --namespace-name "$OS_NAMESPACE" --bucket-name "$name" --par-id "$pid" --force || true
  done
  versions=$(json_or_empty --region "$region" os object list-object-versions \
    --namespace-name "$OS_NAMESPACE" --bucket-name "$name" --all)
  echo "$versions" | jq -r '.data[]? | "\(.name)\t\(.["version-id"] // empty)"' | while IFS=$'\t' read -r obj ver_id; do
    [[ -z "$obj" ]] && continue
    if [[ -n "$ver_id" ]]; then
      oci_try --region "$region" os object delete --namespace-name "$OS_NAMESPACE" \
        --bucket-name "$name" --object-name "$obj" --version-id "$ver_id" --force || true
    fi
  done
  oci_try --region "$region" os bucket delete \
    --namespace-name "$OS_NAMESPACE" --bucket-name "$name" --force || true
}

delete_one() {
  local region="$1" type="$2" id="$3" name="$4"
  local when endpoint group
  case "$type" in
    Bucket) empty_bucket "$region" "$name" ;;
    Instance)
      oci_try --region "$region" compute instance terminate --instance-id "$id" --preserve-boot-volume false --force || true ;;
    InstancePool)
      oci_try --region "$region" compute-management instance-pool terminate --instance-pool-id "$id" --force || true ;;
    Image)
      oci_try --region "$region" compute image delete --image-id "$id" --force || true ;;
    Volume)
      oci_try --region "$region" bv volume delete --volume-id "$id" --force || true ;;
    BootVolume)
      oci_try --region "$region" bv boot-volume delete --boot-volume-id "$id" --force || true ;;
    VolumeBackup)
      oci_try --region "$region" bv backup delete --volume-backup-id "$id" --force || true ;;
    BootVolumeBackup)
      oci_try --region "$region" bv boot-volume-backup delete --boot-volume-backup-id "$id" --force || true ;;
    VolumeGroup|VolumeGroupBackup)
      oci_try --region "$region" bv volume-group delete --volume-group-id "$id" --force || true ;;
    VolumeAttachment)
      oci_try --region "$region" compute volume-attachment delete --volume-attachment-id "$id" --force || true ;;
    Vcn)
      oci_try --region "$region" network vcn delete --vcn-id "$id" --force || true ;;
    Subnet)
      oci_try --region "$region" network subnet delete --subnet-id "$id" --force || true ;;
    Vlan)
      oci_try --region "$region" network vlan delete --vlan-id "$id" --force || true ;;
    RouteTable)
      oci_try --region "$region" network route-table delete --rt-id "$id" --force || true ;;
    SecurityList)
      oci_try --region "$region" network security-list delete --security-list-id "$id" --force || true ;;
    NetworkSecurityGroup)
      oci_try --region "$region" network nsg delete --nsg-id "$id" --force || true ;;
    DhcpOptions)
      oci_try --region "$region" network dhcp-options delete --dhcp-id "$id" --force || true ;;
    InternetGateway)
      oci_try --region "$region" network internet-gateway delete --ig-id "$id" --force || true ;;
    NatGateway)
      oci_try --region "$region" network nat-gateway delete --nat-gateway-id "$id" --force || true ;;
    ServiceGateway)
      oci_try --region "$region" network service-gateway delete --service-gateway-id "$id" --force || true ;;
    LocalPeeringGateway)
      oci_try --region "$region" network local-peering-gateway delete --local-peering-gateway-id "$id" --force || true ;;
    Drg)
      oci_try --region "$region" network drg delete --drg-id "$id" --force || true ;;
    DrgAttachment)
      oci_try --region "$region" network drg-attachment delete --drg-attachment-id "$id" --force || true ;;
    Cpe)
      oci_try --region "$region" network cpe delete --cpe-id "$id" --force || true ;;
    IPSecConnection)
      oci_try --region "$region" network ip-sec-connection delete --ipsc-id "$id" --force || true ;;
    RemotePeeringConnection)
      oci_try --region "$region" network remote-peering-connection delete --rpc-id "$id" --force || true ;;
    PublicIp)
      oci_try --region "$region" network public-ip delete --public-ip-id "$id" --force || true ;;
    VirtualCircuit)
      oci_try --region "$region" network virtual-circuit delete --virtual-circuit-id "$id" --force || true ;;
    CrossConnect)
      oci_try --region "$region" network cross-connect delete --cross-connect-id "$id" --force || true ;;
    CrossConnectGroup)
      oci_try --region "$region" network cross-connect-group delete --cross-connect-group-id "$id" --force || true ;;
    LoadBalancer)
      oci_try --region "$region" lb load-balancer delete --load-balancer-id "$id" --force || true ;;
    NetworkLoadBalancer)
      oci_try --region "$region" nlb network-load-balancer delete --network-load-balancer-id "$id" --force || true ;;
    NetworkFirewall)
      oci_try --region "$region" network-firewall network-firewall delete --network-firewall-id "$id" --force || true ;;
    NetworkFirewallPolicy)
      oci_try --region "$region" network-firewall network-firewall-policy delete --network-firewall-policy-id "$id" --force || true ;;
    AutonomousDatabase)
      oci_try --region "$region" db autonomous-database delete --autonomous-database-id "$id" --force || true ;;
    DbSystem)
      oci_try --region "$region" db system terminate --db-system-id "$id" --force || true ;;
    MysqlDbSystem)
      oci_try --region "$region" mysql db-system delete --db-system-id "$id" --force || true ;;
    PostgresqlDbSystem)
      oci_try --region "$region" psql db-system delete --db-system-id "$id" --force || true ;;
    NosqlTable)
      oci_try --region "$region" nosql table delete --table-name-or-id "$id" --compartment-id "$CURRENT_CID" --force || true ;;
    CloudVmCluster)
      oci_try --region "$region" db cloud-vm-cluster delete --cloud-vm-cluster-id "$id" --force || true ;;
    CloudExadataInfrastructure)
      oci_try --region "$region" db cloud-exadata-infrastructure delete --cloud-exadata-infrastructure-id "$id" --force || true ;;
    FileSystem)
      oci_try --region "$region" fs file-system delete --file-system-id "$id" --force || true ;;
    MountTarget)
      oci_try --region "$region" fs mount-target delete --mount-target-id "$id" --force || true ;;
    Export)
      oci_try --region "$region" fs export delete --export-id "$id" --force || true ;;
    Cluster)
      oci_try --region "$region" ce cluster delete --cluster-id "$id" --force || true ;;
    NodePool)
      oci_try --region "$region" ce node-pool delete --node-pool-id "$id" --force || true ;;
    Bastion)
      oci_try --region "$region" bastion bastion delete --bastion-id "$id" --force || true ;;
    BastionSession)
      oci_try --region "$region" bastion session delete --session-id "$id" --force || true ;;
    Alarm)
      oci_try --region "$region" monitoring alarm delete --alarm-id "$id" --force || true ;;
    OnsTopic|NotificationTopic)
      oci_try --region "$region" ons topic delete --topic-id "$id" --force || true ;;
    OnsSubscription|Subscription)
      oci_try --region "$region" ons subscription delete --subscription-id "$id" --force || true ;;
    Log:*)
      group=${type#Log:}
      oci_try --region "$region" logging log delete --log-group-id "$group" --log-id "$id" --force || true ;;
    LogGroup)
      oci_try --region "$region" logging log-group delete --log-group-id "$id" --force || true ;;
    Log)
      log "skip Log $id ($name): delete it via its log group. A later pass lists logs from each group." ;;
    Key:*)
      endpoint=${type#Key:}
      when=$(deletion_time)
      oci_try --region "$region" kms management key schedule-deletion --key-id "$id" --endpoint "$endpoint" --time-of-deletion "$when" --force || true ;;
    Vault)
      when=$(deletion_time)
      oci_try --region "$region" kms management vault schedule-deletion --vault-id "$id" --time-of-deletion "$when" --force || true ;;
    Secret|VaultSecret)
      when=$(deletion_time)
      oci_try --region "$region" vault secret schedule-secret-deletion --secret-id "$id" --time-of-deletion "$when" --force || true ;;
    Certificate)
      when=$(deletion_time)
      oci_try --region "$region" certs-mgmt certificate schedule-deletion --certificate-id "$id" --time-of-deletion "$when" --force || true ;;
    CertificateAuthority)
      when=$(deletion_time)
      oci_try --region "$region" certs-mgmt certificate-authority schedule-deletion --certificate-authority-id "$id" --time-of-deletion "$when" --force || true ;;
    Policy)
      oci_try --region "$HOME_REGION" iam policy delete --policy-id "$id" --force || true ;;
    Quota)
      oci_try --region "$HOME_REGION" limits quota delete --quota-id "$id" --force || true ;;
    TagDefault)
      oci_try --region "$HOME_REGION" iam tag-default delete --tag-default-id "$id" --force || true ;;
    Budget)
      oci_try --region "$HOME_REGION" budgets budget delete --budget-id "$id" --force || true ;;
    EventRule|Rule)
      oci_try --region "$region" events rule delete --rule-id "$id" --force || true ;;
    ServiceConnector)
      oci_try --region "$region" sch service-connector delete --service-connector-id "$id" --force || true ;;
    OrmStack|Stack)
      oci_try --region "$region" resource-manager stack delete --stack-id "$id" --force || true ;;
    FunctionsFunction)
      oci_try --region "$region" fn function delete --function-id "$id" --force || true ;;
    FunctionsApplication)
      oci_try --region "$region" fn application delete --application-id "$id" --force || true ;;
    ApiGateway|Gateway)
      oci_try --region "$region" api-gateway gateway delete --gateway-id "$id" --force || true ;;
    Deployment|ApiDeployment)
      oci_try --region "$region" api-gateway deployment delete --deployment-id "$id" --force || true ;;
    ApmDomain)
      oci_try --region "$region" apm-control-plane apm-domain delete --apm-domain-id "$id" --force || true ;;
    RedisCluster|OciCacheCluster)
      oci_try --region "$region" redis redis-cluster delete --redis-cluster-id "$id" --force || true ;;
    OpensearchCluster)
      oci_try --region "$region" opensearch cluster delete --opensearch-cluster-id "$id" --force || true ;;
    GoldenGateDeployment)
      oci_try --region "$region" goldengate deployment delete --deployment-id "$id" --force || true ;;
    IntegrationInstance)
      oci_try --region "$region" integration integration-instance delete --integration-instance-id "$id" --force || true ;;
    AnalyticsInstance)
      oci_try --region "$region" analytics analytics-instance delete --analytics-instance-id "$id" --force || true ;;
    ContainerInstance)
      oci_try --region "$region" container-instances container-instance delete --container-instance-id "$id" --force || true ;;
    WebAppFirewall)
      oci_try --region "$region" waf web-app-firewall delete --web-app-firewall-id "$id" --force || true ;;
    WafPolicy)
      oci_try --region "$region" waf web-app-firewall-policy delete --web-app-firewall-policy-id "$id" --force || true ;;
    Sender|EmailSender)
      oci_try --region "$region" email sender delete --sender-id "$id" --force || true ;;
    DrProtectionGroup)
      oci_try --region "$region" disaster-recovery dr-protection-group delete --dr-protection-group-id "$id" --force || true ;;
    GenerativeAiEndpoint)
      oci_try --region "$region" generative-ai endpoint delete --endpoint-id "$id" --force || true ;;
    DedicatedAiCluster)
      oci_try --region "$region" generative-ai dedicated-ai-cluster delete --dedicated-ai-cluster-id "$id" --force || true ;;
    DataSafeTargetDatabase)
      oci_try --region "$region" data-safe target-database delete --target-database-id "$id" --force || true ;;
    DataSafePrivateEndpoint)
      oci_try --region "$region" data-safe private-endpoint delete --private-endpoint-id "$id" --force || true ;;
    SecurityZone)
      oci_try --region "$region" cloud-guard security-zone delete --security-zone-id "$id" --force || true ;;
    SecurityRecipe)
      oci_try --region "$region" cloud-guard security-recipe delete --security-recipe-id "$id" --force || true ;;
    CloudGuardTarget)
      oci_try --region "$region" cloud-guard target delete --target-id "$id" --force || true ;;
    *)
      log "unsupported ${type} ${id} (${name}) in ${region}"
      printf '%s\t%s\t%s\t%s\n' "$region" "$type" "$id" "$name" >> "$TMPDIR_CLEAN/unsupported.tsv"
      ;;
  esac
}

list_regions() {
  if [[ -n "${REGION_ARGS// /}" ]]; then
    # shellcheck disable=SC2086
    printf '%s\n' $REGION_ARGS
    return 0
  fi
  json_or_empty iam region-subscription list --tenancy-id "$TENANCY_ID" --all \
    | jq -r '.data[]? | .["region-name"]'
}

collect_compartment() {
  local cid="$1" region
  collect_policies "$cid"
  collect_quotas "$cid"
  collect_tag_defaults "$cid"
  while IFS= read -r region; do
    [[ -z "$region" ]] && continue
    log "  search $region"
    collect_search "$region" "$cid"
    collect_buckets "$region" "$cid"
    collect_logs "$region" "$cid"
    collect_kms "$region" "$cid"
  done < <(list_regions)
}

empty_compartment_resources() {
  local cid="$1" count pri region type id name
  CURRENT_CID="$cid"
  local p
  for p in $(seq 1 "$MAX_PASSES"); do
    reset_pass_files
    log "pass $p/$MAX_PASSES for $cid"
    collect_compartment "$cid"
    count=$(grep -c . "$TMPDIR_CLEAN/resources.tsv" || true)
    log "  deletable resources: $count"
    [[ "$count" -eq 0 ]] && break
    sort -n -t "$(printf '\t')" -k1,1 "$TMPDIR_CLEAN/resources.tsv" | while IFS=$'\t' read -r pri region type id name; do
      log "[$pri] $region $type $id ${name}"
      delete_one "$region" "$type" "$id" "$name"
    done
    if [[ "$APPLY" -eq 0 ]]; then
      break
    fi
  done
}

list_children() {
  local cid="$1"
  json_or_empty iam compartment list --region "$HOME_REGION" \
    --compartment-id "$cid" --compartment-id-in-subtree false \
    --access-level ACCESSIBLE --all \
    | jq -r '.data[]? | select(.["lifecycle-state"]=="ACTIVE" or .["lifecycle-state"]=="INACTIVE") | .id'
}

delete_compartment_ocid() {
  local cid="$1"
  oci_try iam compartment delete --region "$HOME_REGION" --compartment-id "$cid" --force || true
}

clean_tree() {
  local cid="$1" depth="$2" child name
  if [[ "$depth" -gt 15 ]]; then
    echo "compartment nesting deeper than 15; stopping." >&2
    exit 1
  fi
  while IFS= read -r child; do
    [[ -z "$child" ]] && continue
    clean_tree "$child" $((depth + 1))
  done < <(list_children "$cid")

  name=$(oci iam compartment get --region "$HOME_REGION" --compartment-id "$cid" --query 'data.name' --raw-output 2>/dev/null || echo "$cid")
  log ""
  log "=== compartment ${name} (${cid}) ==="
  empty_compartment_resources "$cid"

  if [[ "$cid" == "$COMPARTMENT_ID" ]]; then
    if [[ "$DELETE_COMPARTMENT" -eq 1 ]]; then
      delete_compartment_ocid "$cid"
    fi
  else
    log "child compartment ${name} blocks the parent until it is deleted"
    if [[ "$APPLY" -eq 1 ]]; then
      delete_compartment_ocid "$cid"
    else
      log "dry-run: oci iam compartment delete --region $HOME_REGION --compartment-id $cid --force"
    fi
  fi
}

resolve_tenancy() {
  local cur="$1" parent
  while true; do
    parent=$(oci iam compartment get --compartment-id "$cur" --query 'data."compartment-id"' --raw-output 2>/dev/null || true)
    if [[ -z "$parent" || "$parent" == "null" ]]; then
      TENANCY_ID="$cur"
      return 0
    fi
    cur="$parent"
  done
}

main() {
  local parent info
  info=$(oci iam compartment get --compartment-id "$COMPARTMENT_ID" --output json)
  parent=$(echo "$info" | jq -r '.data["compartment-id"] // empty')
  TARGET_NAME=$(echo "$info" | jq -r '.data.name')
  if [[ -z "$parent" || "$parent" == "null" ]]; then
    echo "Refusing to clean the tenancy root ($TARGET_NAME)." >&2
    exit 1
  fi
  resolve_tenancy "$parent"
  HOME_REGION=$(json_or_empty iam region-subscription list --tenancy-id "$TENANCY_ID" --all \
    | jq -r '[.data[]? | select(.["is-home-region"]==true) | .["region-name"]] | first // empty')
  if [[ -z "$HOME_REGION" ]]; then
    echo "Could not resolve the home region for tenancy $TENANCY_ID." >&2
    exit 1
  fi
  OS_NAMESPACE=$(oci os ns get --query data --raw-output 2>/dev/null || true)

  log "compartment: $TARGET_NAME"
  log "id:          $COMPARTMENT_ID"
  log "parent:      $parent"
  log "tenancy:     $TENANCY_ID"
  log "home region: $HOME_REGION"
  if [[ "$APPLY" -eq 1 ]]; then
    log "mode:        apply (resources and child compartments will be deleted)"
  else
    log "mode:        dry-run (pass --apply to delete)"
  fi
  if [[ "$DELETE_COMPARTMENT" -eq 1 ]]; then
    log "also delete the named compartment after it is empty"
  fi

  if [[ "$APPLY" -eq 1 && "$YES" -eq 0 ]]; then
    if [[ ! -t 0 ]]; then
      echo "Not a terminal. Pass --yes to apply without a prompt." >&2
      exit 1
    fi
    printf 'Type the compartment name (%s) to continue: ' "$TARGET_NAME"
    local typed
    IFS= read -r typed
    if [[ "$typed" != "$TARGET_NAME" ]]; then
      echo "Name did not match. Nothing deleted." >&2
      exit 1
    fi
  fi

  : > "$TMPDIR_CLEAN/unsupported.tsv"
  : > "$TMPDIR_CLEAN/waiting.all"
  clean_tree "$COMPARTMENT_ID" 0

  log ""
  log "=== still waiting (deletion already scheduled or in progress) ==="
  if [[ -s "$TMPDIR_CLEAN/waiting.all" ]]; then
    sort -u "$TMPDIR_CLEAN/waiting.all"
    log "Keys, vaults, and certificates stay in the compartment until the waiting period ends. Re-run this script after that, then delete the compartment."
  else
    log "(none)"
  fi
  if [[ -s "$TMPDIR_CLEAN/unsupported.tsv" ]]; then
    log ""
    log "=== no delete command for these resource types ==="
    sort -u "$TMPDIR_CLEAN/unsupported.tsv"
    log "These still cause Compartment Not Empty. Delete them in the console, then re-run."
  fi
  if [[ "$APPLY" -eq 1 && "$DELETE_COMPARTMENT" -eq 0 ]]; then
    log ""
    log "Resources were deleted. Re-run with --delete-compartment after waiting resources are gone."
  fi
}

main
