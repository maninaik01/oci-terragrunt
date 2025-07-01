# live/dev/network/terragrunt.hcl

dependency "compartment" {
  config_path = "../compartment-01"
}

include {
  path = find_in_parent_folders()
}

locals {
  env    = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals
  common = read_terragrunt_config(find_in_parent_folders("common.hcl")).locals
}

terraform {
  source = "git::https://github.com/oracle-terraform-modules/terraform-oci-vcn.git"

  extra_arguments "common_vars" {
    commands = get_terraform_commands_that_need_vars()
    arguments = [
      "-var-file=${get_terragrunt_dir()}/network.tfvars"

    ]
  }
}

inputs = {
  compartment_id = dependency.compartment.outputs.compartment_id
  vcn_name   =  join("-", [local.common.customer_name, local.env.environment_name])
  tenancy_id = local.common.tenancy_ocid
  freeform_tags = {
    environment = local.env.environment_name
    customer_name = local.common.customer_name
  }
  attached_drg_id  = null
}
