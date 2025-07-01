dependency "compartment" {
  config_path = "../../management/compartment"
}

dependency "management_drg" {
  config_path = "../../management/drg"
}

dependency "network" {
  config_path = "../network"
}

include {
  path = find_in_parent_folders()
}

locals {
  env    = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals
  common = read_terragrunt_config(find_in_parent_folders("common.hcl")).locals
}

terraform {
  source = "../../../modules/drg"

#   extra_arguments "common_vars" {
#     commands = get_terraform_commands_that_need_vars()
#     arguments = [
#       "-var-file=${get_terragrunt_dir()}/drg_attachment.tfvars"
#     ]
#   }
}

inputs = {
  compartment_id = dependency.compartment.outputs.compartment_id
  drg_display_name   = join("-", [local.common.customer_name, local.env.environment_name, "drg-attachment"])


  create_drg_attachment = true

  vcn_id                = dependency.network.outputs.vcn_id
  drg_id                = dependency.management_drg.outputs.drg_id
}
