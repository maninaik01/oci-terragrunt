output "bucket_name" {
  value = oci_objectstorage_bucket.terraform_state_bucket.name
}

output "namespace" {
  value = data.oci_objectstorage_namespace.namespace.namespace
}