# exadata-snapshot on OCI Resource Manager

This directory is a stack you can upload as-is. The module source is vendored under `modules/`.

1. Zip this directory. Leave out any `.terraform` directory.
2. In Resource Manager, create a stack from the zip and select Terraform **1.5.x**.
3. Resource Manager fills `tenancy_ocid` and `region`. Set `compartment_ocid` and the other required fields.
4. Run Plan, then Apply.

Change parameters in the stack form. Edit Terraform only when you need a value the form does not show.
Regenerate this directory with `python3 scripts/tf15_resource_manager.py sync` after the module changes.
