

include {
  path = find_in_parent_folders()
}

locals {
  env    = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals
  common = read_terragrunt_config(find_in_parent_folders("common.hcl")).locals
}

dependency "compartment" {
  config_path = "../compartment"
}

dependency "network" {
  config_path = "../network"
}

terraform {
  source = "../../../modules/drg"

}

inputs = {
  compartment_id = dependency.compartment.outputs.compartment_id
  drg_display_name   = join("-", [local.common.customer_name, local.env.environment_name, "drg"])

  create_drg = true
  
  create_drg_attachment = true

  vcn_id            = dependency.network.outputs.vcn_id

  route_rules = [
    {
      route_table_id = dependency.network.outputs.ig_route_id
      destination = "10.1.0.0/16"
      destination_type = "CIDR_BLOCK"
      description = "Route Dev VCN via DRG"
    },
    {
      route_table_id = dependency.network.outputs.nat_route_id
      destination = "10.1.0.0/16"
      destination_type = "CIDR_BLOCK"
      description = "Route Dev VCN via DRG"
    },
    {
      route_table_id = dependency.network.outputs.sgw_route_id
      destination = "10.1.0.0/16"
      destination_type = "CIDR_BLOCK"
      description = "Route Dev VCN via DRG"
    }
  ]
}
