# variable "route_rules" {
#   type = list(object({
#     route_table_id   = string
#     destination      = string
#     destination_type = string
#     description      = optional(string, "")
#   }))
#   default = []
#   description = "List of route rules to add on the route tables"
# }

# resource "oci_core_route_rule" "drg_routes" {
#   for_each = { for idx, rule in var.route_rules : idx => rule }

#   route_table_id    = each.value.route_table_id
#   destination       = each.value.destination
#   destination_type  = each.value.destination_type
#   network_entity_id = local.resolved_drg_id
#   description      = each.value.description
# }
