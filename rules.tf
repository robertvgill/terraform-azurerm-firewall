resource "azurerm_firewall_nat_rule_collection" "afw_nat" {
  for_each = try({ for collection in var.afw_firewall_nat_rules : collection.name => collection }, toset([]))

  name                = lower(format("fw-nat-rule-dnat-%s", each.key))
  azure_firewall_name = azurerm_firewall.afw[0].name
  resource_group_name = var.rg_resource_group_name
  priority            = each.value.priority
  action              = each.value.action
  dynamic "rule" {
    for_each = each.value.rules
    content {
      name                  = rule.value.name
      source_addresses      = rule.value.source_addresses
      source_ip_groups      = rule.value.source_ip_groups
      destination_ports     = rule.value.destination_ports
      destination_addresses = rule.value.destination_addresses
      translated_address    = rule.value.translated_address
      translated_port       = rule.value.translated_port
      protocols             = rule.value.protocols
    }
  }
}

resource "azurerm_firewall_network_rule_collection" "afw_net" {
  for_each = try({ for collection in var.afw_firewall_network_rules : collection.name => collection }, toset([]))

  name                = lower(format("fw-net-rule-allow-%s", each.key))
  azure_firewall_name = azurerm_firewall.afw[0].name
  resource_group_name = var.rg_resource_group_name
  priority            = each.value.priority
  action              = each.value.action

  dynamic "rule" {
    for_each = each.value.rules
    content {
      name                  = rule.value.name
      source_addresses      = rule.value.source_addresses
      source_ip_groups      = rule.value.source_ip_groups
      destination_addresses = rule.value.destination_addresses
      destination_ip_groups = rule.value.destination_ip_groups
      destination_fqdns     = rule.value.destination_fqdns
      destination_ports     = rule.value.destination_ports
      protocols             = rule.value.protocols
    }
  }
}

resource "azurerm_firewall_application_rule_collection" "afw_app" {
  for_each = try({ for collection in var.afw_firewall_application_rules : collection.name => collection }, toset([]))

  name                = lower(format("fw-app-rule-allow-%s", each.key))
  azure_firewall_name = azurerm_firewall.afw[0].name
  resource_group_name = var.rg_resource_group_name
  priority            = each.value.priority
  action              = each.value.action

  dynamic "rule" {
    for_each = each.value.rules
    content {
      name             = rule.value.name
      source_addresses = rule.value.source_addresses
      source_ip_groups = rule.value.source_ip_groups
      target_fqdns     = rule.value.target_fqdns
      dynamic "protocol" {
        for_each = rule.value.protocols
        content {
          port = protocol.value.port
          type = protocol.value.type
        }
      }
    }
  }
}