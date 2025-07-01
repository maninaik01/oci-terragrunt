variable "customer_name" {
  type        = string
  description = "Customer name to prefix the bucket"
}

variable "region" {
  type        = string
  description = "OCI region"
}

variable "compartment_id" {
  type        = string
  description = "Compartment ID to create the bucket in"
}

variable "tenancy_ocid" {
  type        = string
  description = "OCI Tenancy OCID"
}

variable "user_ocid" {
  type        = string
  description = "OCI User OCID"
}

variable "fingerprint" {
  type        = string
  description = "OCI API key fingerprint"
}

variable "private_key_path" {
  type        = string
  description = "Path to the OCI private key file"
}
