## vnet
data "azurerm_virtual_network" "alz" {
  count               = var.afw_firewall_create ? 1 : 0

  name                = format("%s", var.nw_virtual_network_name)
  resource_group_name = var.rg_resource_group_name
}