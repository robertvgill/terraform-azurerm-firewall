resource "azurerm_firewall" "afw" {
  count      = var.afw_firewall_create ? 1 : 0

  depends_on = [
    data.azurerm_virtual_network.alz,
    azurerm_public_ip_prefix.afw_pref,
    azurerm_public_ip.afw_pip,
    azurerm_public_ip.afw_mgmt_pip,
  ]

  name                = format("%s", var.afw_firewall_config.name)
  resource_group_name = var.rg_resource_group_name
  location            = var.rg_location
  sku_name            = var.afw_firewall_config.sku_name
  sku_tier            = var.afw_firewall_config.sku_tier
//  firewall_policy_id  = var.afw_firewall_policy != null ? azurerm_firewall_policy.afw_policy.0.id : null
  dns_servers         = var.afw_firewall_config.dns_servers
  private_ip_ranges   = var.afw_firewall_config.private_ip_ranges
  threat_intel_mode   = lookup(var.afw_firewall_config, "threat_intel_mode", "Alert")
  zones               = var.afw_firewall_config.zones
  tags                = merge({ "ResourceName" = format("%s", var.afw_firewall_config.name) }, var.tags, )

  dynamic "ip_configuration" {
    for_each = local.public_ip_map
    iterator = ip
    content {
      name                 = ip.key
      subnet_id            = ip.key == var.afw_public_ip_names[0] ? azurerm_subnet.afw["afw"].id : null
      public_ip_address_id = azurerm_public_ip.afw_pip[ip.key].id
    }
  }

  dynamic "management_ip_configuration" {
    for_each = var.afw_enable_forced_tunneling ? [1] : []
    content {
      name                 = lower("${var.afw_firewall_config.name}-forced-tunnel")
      subnet_id            = azurerm_subnet.afw["afw-mgmt"].id
      public_ip_address_id = azurerm_public_ip.afw_mgmt_pip.0.id
    }
  }

  dynamic "virtual_hub" {
    for_each = var.afw_virtual_hub != null ? [var.afw_virtual_hub] : []
    content {
      virtual_hub_id  = virtual_hub.value.virtual_hub_id
      public_ip_count = virtual_hub.value.public_ip_count
    }
  }
}
