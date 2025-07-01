locals {
  env    = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals
  common = read_terragrunt_config(find_in_parent_folders("common.hcl")).locals
  ssh_pub_key_file = "~/.ssh/id_ed25519.pub"
}

include {
  path = find_in_parent_folders()
}

dependency "compartment" {
  config_path = "../compartment-01"
}

dependency "network" {
  config_path = "../network-02"
  mock_outputs = {
    vcn_id              = "ocid1.vcn.oc1..mock"
    internet_gateway_id = "ocid1.internetgateway.oc1..mock"
    nat_gateway_id      = "ocid1.natgateway.oc1..mock"
    service_gateway_id  = "ocid1.servicegateway.oc1..mock"
    subnet_id = {
      public_subnets  = "ocid1.subnet.oc1..public"
      private_subnets = "ocid1.subnet.oc1..private"
      db_subnets      = "ocid1.subnet.oc1..db"
    }
  }
}


dependency "security_list" {
  config_path = "../app-sg-03"
}

terraform {
  source = "git::https://github.com/oracle-terraform-modules/terraform-oci-compute-instance.git"
  
  extra_arguments "common_vars" {
    commands = get_terraform_commands_that_need_vars()
    arguments = [
      "-var-file=${get_terragrunt_dir()}/compute.tfvars",
    ]
  }
}

inputs = {
  tenancy_ocid     = local.env.tenancy_ocid
  user_ocid        = local.env.user_ocid
  fingerprint      = local.env.fingerprint
  private_key_path = local.env.private_key_path
  region           = local.env.region

  compartment_ocid   = dependency.compartment.outputs.compartment_id
  subnet_ocids        = [dependency.network.outputs.subnet_id["private_subnet"]]
  display_name     = join("-", [local.common.customer_name, local.env.environment_name, "app1"])


  ssh_authorized_keys = local.ssh_pub_key_file

  metadata = {
    ssh_authorized_keys = file(local.ssh_pub_key_file)
  }

  assign_public_ip  = false

  security_list_ids = [dependency.security_list.outputs.security_list_id]

  freeform_tags = {
    environment = local.env.environment_name
    project     = local.common.customer_name
  }
}
