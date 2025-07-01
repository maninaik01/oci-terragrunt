variable "compartment_id" {
  type        = string
  description = "OCI compartment OCID"
}

variable "vcn_id" {
  type        = string
  description = "OCI VCN OCID"
}

variable "display_name" {
  type        = string
  description = "Security list display name"
}

variable "ingress_security_rules" {
  type = list(object({
    protocol = string
    source   = string
    tcp_min  = number
    tcp_max  = number
  }))
  description = "List of ingress rules"
  default     = []
}

variable "egress_security_rules" {
  type = list(object({
    protocol    = string
    destination = string
  }))
  description = "List of egress rules"
  default     = []
}

resource "oci_core_security_list" "this" {
  compartment_id = var.compartment_id
  vcn_id         = var.vcn_id
  display_name   = var.display_name

  dynamic "ingress_security_rules" {
    for_each = var.ingress_security_rules
    content {
      protocol = ingress_security_rules.value.protocol
      source   = ingress_security_rules.value.source

      tcp_options {
        min = ingress_security_rules.value.tcp_min
        max = ingress_security_rules.value.tcp_max
      }
    }
  }

  dynamic "egress_security_rules" {
    for_each = var.egress_security_rules
    content {
      protocol    = egress_security_rules.value.protocol
      destination = egress_security_rules.value.destination
    }
  }
}

output "security_list_id" {
  description = "The OCID of the created security list"
  value       = oci_core_security_list.this.id
}

output "display_name" {
  description = "The display name of the security list"
  value       = oci_core_security_list.this.display_name
}
