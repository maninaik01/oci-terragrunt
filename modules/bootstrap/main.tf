terraform {
  required_version = "= 1.9.1"

  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "= 7.5.0"
    }
  }
}

provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}

data "oci_objectstorage_namespace" "namespace" {}

resource "oci_objectstorage_bucket" "terraform_state_bucket" {
  namespace      = data.oci_objectstorage_namespace.namespace.namespace
  compartment_id = var.compartment_id
  name           = "${var.customer_name}-terraform-state-file"
  storage_tier   = "Standard"
}
