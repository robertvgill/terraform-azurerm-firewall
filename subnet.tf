## subnets
resource "azurerm_subnet" "afw" {
  for_each            = var.afw_subnets

  depends_on          = [
    data.azurerm_virtual_network.alz,
  ]

  name                                           = each.value.subnet_name
  resource_group_name                            = var.rg_resource_group_name
  virtual_network_name                           = data.azurerm_virtual_network.alz[0].name
  address_prefixes                               = each.value.subnet_address_prefix
  service_endpoints                              = lookup(each.value, "service_endpoints", [])
  enforce_private_link_endpoint_network_policies = lookup(each.value, "enforce_private_link_endpoint_network_policies", null)
  enforce_private_link_service_network_policies  = lookup(each.value, "enforce_private_link_service_network_policies", null)

  dynamic "delegation" {
    for_each = lookup(each.value, "delegation", {}) != {} ? [1] : []
    content {
      name = lookup(each.value.delegation, "name", null)
      service_delegation {
        name    = lookup(each.value.delegation.service_delegation, "name", null)
        actions = lookup(each.value.delegation.service_delegation, "actions", null)
      }
    }
  }

  lifecycle {
    prevent_destroy = false
  }
}
