#!/usr/bin/env bash
# Load a named OCI credential bundle (multiple accounts).
#
# Switch account (no source needed — apply exports in current shell):
#   eval "$(./scripts/oci-use.sh ACI_ACCOUNT_NAME)"
#
# Or use the shell functions (bash):
#   source scripts/oci-use.sh
#   oci_use_list
#   oci_use ACI_ACCOUNT_NAME
#
# List accounts:
#   ./scripts/oci-use.sh list
#
# Override directory (default: repo credentials/):
#   export OCI_CREDENTIALS_DIR=/path/to/dir
#
# shellcheck shell=bash

_oci_use_root() {
  cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd
}

OCI_CREDENTIALS_DIR="${OCI_CREDENTIALS_DIR:-$(_oci_use_root)/credentials}"

_oci_use_unset_tenant_vars() {
  unset OCI_TENANCY_OCID OCI_USER_OCID OCI_FINGERPRINT OCI_PRIVATE_KEY_PATH OCI_PRIVATE_KEY \
    OCI_REGION OCI_PRIVATE_KEY_PASSWORD OCI_CONFIG_FILE_PROFILE TF_VAR_config_file_profile
  unset TF_VAR_compartment_id TF_VAR_tenancy_ocid TF_VAR_home_region
}

oci_use_list() {
  local d="$OCI_CREDENTIALS_DIR"
  if [[ ! -d "$d" ]]; then
    echo "No credentials directory: $d" >&2
    return 1
  fi
  local f out=()
  shopt -s nullglob
  for f in "$d"/*.env; do
    out+=("$(basename "$f" .env)")
  done
  shopt -u nullglob
  if [[ ${#out[@]} -eq 0 ]]; then
    echo "(no credentials/*.env files; copy credentials/example.env.example)" >&2
    return 0
  fi
  printf '%s\n' "${out[@]}" | sort -u
}

# Print eval-safe export lines for the given account (stdout). Messages on stderr.
_oci_use_emit_eval() {
  local name="$1"
  local file="${OCI_CREDENTIALS_DIR}/${name}.env"
  if [[ ! -f "$file" ]]; then
    echo "oci-use: no credentials file: $file" >&2
    echo "Available accounts:" >&2
    oci_use_list >&2 || true
    return 1
  fi
  (
    _oci_use_unset_tenant_vars
    set -a
    # shellcheck disable=SC1090
    source "$file"
    set +a
    # shellcheck disable=SC2030
    export OCI_ACTIVE_CREDENTIAL_PROFILE="$name"
    local var
    while IFS= read -r var; do
      [[ "$var" =~ ^(OCI_|TF_VAR_) ]] || continue
      printf 'export %s=%q\n' "$var" "${!var}"
    done < <(compgen -e | LC_ALL=C sort -u)
  ) || return 1
  echo "Active credential account: ${name} (exports applied if you used eval)" >&2
}

oci_use() {
  local name="${1:-}"
  if [[ -z "$name" ]]; then
    echo "usage: oci_use <account>  (loads ${OCI_CREDENTIALS_DIR}/<account>.env)" >&2
    return 1
  fi
  if [[ "$name" == list ]]; then
    oci_use_list
    return 0
  fi

  local file="${OCI_CREDENTIALS_DIR}/${name}.env"
  if [[ ! -f "$file" ]]; then
    echo "oci_use: profile not found: $file" >&2
    echo "Available accounts:" >&2
    oci_use_list >&2 || true
    return 1
  fi

  _oci_use_unset_tenant_vars
  set -a
  # shellcheck disable=SC1090
  source "$file"
  set +a
  # shellcheck disable=SC2031
  export OCI_ACTIVE_CREDENTIAL_PROFILE="$name"
  echo "OCI_ACTIVE_CREDENTIAL_PROFILE=${name}" >&2
}

_oci_use_usage() {
  cat >&2 <<'EOF'
Usage:
  ./scripts/oci-use.sh <account>     Switch to credentials/<account>.env — use:
                                    eval "$(./scripts/oci-use.sh <account>)"
  ./scripts/oci-use.sh list         List account names (credentials/*.env)
  source scripts/oci-use.sh         Define oci_use / oci_use_list, then:
  oci_use <account>
EOF
}

if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
  if [[ $# -gt 0 ]]; then
    oci_use "$@"
  fi
else
  case "${1:-}" in
    ""|-h|--help|help)
      _oci_use_usage
      [[ -n "${1:-}" ]] || exit 1
      exit 0
      ;;
    list|ls)
      oci_use_list
      ;;
    *)
      _oci_use_emit_eval "$1"
      ;;
  esac
fi
