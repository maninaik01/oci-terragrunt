resource "oci_identity_compartment" "this" {
  compartment_id = var.tenancy_ocid
  name           = "${var.customer_name}-${var.environment_name}-cmp"
  description    = "Compartment for ${var.customer_name} in ${var.environment_name} environment"
  enable_delete  = var.enable_delete
}

output "compartment_id" {
  value = oci_identity_compartment.this.id
}
