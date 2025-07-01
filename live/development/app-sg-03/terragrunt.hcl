locals {
  env    = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals
  common = read_terragrunt_config(find_in_parent_folders("common.hcl")).locals
}

include {
  path = find_in_parent_folders()
}

dependency "compartment" {
  config_path = "../compartment"
}

dependency "network" {
  config_path = "../network"
}

terraform {
  source = "../../../modules/security-list"
}

inputs = {
  compartment_id = dependency.compartment.outputs.compartment_id
  vcn_id         = dependency.network.outputs.vcn_id
  display_name   = "bastion-sg"

  ingress_security_rules = [
    {
      protocol = "6"        # TCP
      source   = "10.0.0.0/8"
      tcp_min  = 22
      tcp_max  = 22
    }
  ]

  egress_security_rules = [
    {
      protocol    = "all"
      destination = "0.0.0.0/0"
    }
  ]
}
