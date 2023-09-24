resource "azurerm_public_ip_prefix" "afw_pref" {
  count               = var.afw_firewall_create ? 1 : 0

  name                = lower("${var.afw_firewall_config.name}-pip-prefix")
  resource_group_name = var.rg_resource_group_name
  location            = var.rg_location
  prefix_length       = var.afw_public_ip_prefix_length
  tags                = merge({ "ResourceName" = lower("${var.afw_firewall_config.name}-pip-prefix") }, var.tags, )
}

resource "azurerm_public_ip" "afw_pip" {
  for_each            = local.public_ip_map

  name                = lower("pip-${var.afw_firewall_config.name}-${each.key}")
  resource_group_name = var.rg_resource_group_name
  location            = var.rg_location
  allocation_method   = var.afw_public_ip_allocation_method
  sku                 = var.afw_public_ip_sku
  sku_tier            = var.afw_public_ip_sku_tier
  domain_name_label   = var.afw_domain_name_label
  zones               = var.afw_public_ip_availability_zone
  public_ip_prefix_id = azurerm_public_ip_prefix.afw_pref[0].id
  tags                = merge({ "ResourceName" = lower("pip-${var.afw_firewall_config.name}-${each.key}") }, var.tags, )
}

resource "azurerm_public_ip" "afw_mgmt_pip" {
  count               = var.afw_enable_forced_tunneling ? 1 : 0

  name                = lower("pip-${var.afw_firewall_config.name}-fw-mgmt")
  resource_group_name = var.rg_resource_group_name
  location            = var.rg_location
  allocation_method   = var.afw_public_ip_allocation_method
  sku                 = var.afw_public_ip_sku
  sku_tier            = var.afw_public_ip_sku_tier
  domain_name_label   = var.afw_domain_name_label
  zones               = var.afw_public_ip_availability_zone
  tags                = merge({ "ResourceName" = lower("pip-${var.afw_firewall_config.name}-fw-mgmt") }, var.tags, )
}