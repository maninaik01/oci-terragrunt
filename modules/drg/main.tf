variable "create_drg" {
  type    = bool
  default = false
}

variable "create_drg_attachment" {
  type    = bool
  default = false
}

variable "vcn_id" {
  type = string
}

variable "compartment_id" {
  type = string
}

variable "drg_display_name" {
  type    = string
  default = "default-drg"
}

# Optional: pass external DRG ID when attaching to external DRG
variable "drg_id" {
  type    = string
  default = null
}

resource "oci_core_drg" "this" {
  count          = var.create_drg ? 1 : 0
  compartment_id = var.compartment_id
  display_name   = var.drg_display_name
}

# Choose DRG ID to attach to: either external or just-created
locals {
  resolved_drg_id = var.create_drg ? oci_core_drg.this[0].id : var.drg_id
}

resource "oci_core_drg_attachment" "this" {
  count          = var.create_drg_attachment ? 1 : 0
  drg_id         = local.resolved_drg_id
  vcn_id         = var.vcn_id
  display_name   = "${var.drg_display_name}-attachment"
}

output "drg_id" {
  value       = var.create_drg ? oci_core_drg.this[0].id : var.drg_id
  description = "The OCID of the DRG (either created or passed in)"
}

output "drg_attachment_id" {
  value       = var.create_drg_attachment ? oci_core_drg_attachment.this[0].id : null
  description = "The OCID of the DRG attachment"
}
