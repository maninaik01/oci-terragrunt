locals {
  env    = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals
  common = read_terragrunt_config(find_in_parent_folders("common.hcl")).locals
}

remote_state {
  backend = "oci"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    namespace        = local.common.bucket_namespace
    bucket           = local.common.bucket_name
    key              = "${path_relative_to_include()}/terraform.tfstate"
    region           = local.common.region
    tenancy_ocid     = local.common.tenancy_ocid
    user_ocid        = local.common.user_ocid
    fingerprint      = local.common.fingerprint
    private_key_path = local.common.private_key_path
    auth             = "APIKey"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "oci" {
  tenancy_ocid     = "${local.common.tenancy_ocid}"
  user_ocid        = "${local.common.user_ocid}"
  fingerprint      = "${local.common.fingerprint}"
  private_key_path = "${local.common.private_key_path}"
  region           = "${local.common.region}"
}
EOF
}

inputs = merge(
  local.env,
  local.common,
)
