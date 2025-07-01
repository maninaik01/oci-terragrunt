
include {
  path = find_in_parent_folders()
}

locals {
  env    = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals
  common = read_terragrunt_config(find_in_parent_folders("common.hcl")).locals
}

terraform {
  source = "../../../modules/oci-compartment"
}

inputs = {
  customer_name = local.common.customer_name
  environment_name = local.env.environment_name

}