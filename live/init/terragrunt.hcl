
locals {
  common = read_terragrunt_config(find_in_parent_folders("common.hcl")).locals
}

terraform {
  source = "../../modules/bootstrap"
}

inputs = {
  customer_name  = local.common.customer_name
  region         = local.common.region
  compartment_id = local.common.tenancy_ocid
  tenancy_ocid   = local.common.tenancy_ocid
  user_ocid      = local.common.user_ocid
  fingerprint    = local.common.fingerprint
  private_key_path = local.common.private_key_path
}