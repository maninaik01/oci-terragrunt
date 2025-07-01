variable "tenancy_ocid" {
  type        = string
  description = "OCID of the tenancy where compartment will be created"
}

variable "customer_name" {
  type        = string
  description = "Customer name prefix for compartment"
}

variable "environment_name" {
  type        = string
  description = "Environment name prefix for compartment"
}

variable "enable_delete" {
  type    = bool
  default = true
}
