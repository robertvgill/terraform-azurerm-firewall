## resource group
variable "rg_resource_group_name" {
  description = "The name of the resource group in which to create the storage account."
  type        = string
  default     = null
}

variable "rg_location" {
  description = "Specifies the supported Azure location where the resource should be created."
  type        = string
  default     = null
}

## vnet
variable "nw_virtual_network_name" {
  description = "The name of the virtual network."
  type        = string
}

variable "nw_address_space" {
  description = "The address space to be used for the Azure virtual network."
  default     = []
}

variable "nw_dns_servers" {
  description = "List of dns servers to use for virtual network."
  default     = []
}

## azure firewall
variable "afw_firewall_create" {
  description = "Controls if Azure Firewall should be created."
  type        = bool
}

variable "afw_firewall_config" {
  type = object({
    name              = string
    sku_name          = string
    sku_tier          = string
    dns_servers       = list(string)
    private_ip_ranges = list(string)
    threat_intel_mode = string
    zones             = list(string)
  })
  default     = null
}

variable "afw_enable_forced_tunneling" {
  description = "Route all Internet-bound traffic to a designated next hop instead of going directly to the Internet."
  default     = false
}

variable "afw_virtual_hub" {
  description = "An Azure Virtual WAN Hub with associated security and routing policies configured by Azure Firewall Manager. Use secured virtual hubs to easily create hub-and-spoke and transitive architectures with native security services for traffic governance and protection."
  type = object({
    virtual_hub_id  = string
    public_ip_count = number
  })
  default = null
}

variable "afw_subnets" {
  description = "For each subnet, create an object that contain fields."
  default     = {}
}

variable "afw_public_ip_prefix_length" {
  description = "Specifies the number of bits of the prefix. The value can be set between 0 (4,294,967,296 addresses) and 31 (2 addresses)."
  default     = null
}

variable "afw_public_ip_names" {
  description = "Public ips is a list of ip names that are connected to the firewall. At least one is required."
  type        = list(string)
  default     = ["fw-public"]
}

variable "afw_public_ip_allocation_method" {
  description = "Defines the allocation method for this IP address. Possible values are `Static` or `Dynamic`."
  default     = "Static"
}

variable "afw_public_ip_sku" {
  description = "The SKU of the Public IP. Accepted values are `Basic` and `Standard`."
  default     = "Standard"
}

variable "afw_public_ip_sku_tier" {
  description = "The SKU Tier that should be used for the Public IP. Possible values are `Regional` and `Global`."
  default     = "Regional"
}

variable "afw_domain_name_label" {
  description = "Label for the Domain Name. Will be used to make up the FQDN. If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system."
  default     = null
}

variable "afw_public_ip_availability_zone" {
  description = "The availability zone to allocate the Public IP in. Possible values are `Zone-Redundant`, `1`,`2`,`3`, and `No-Zone`."
  default     = null
}

variable "afw_firewall_nat_rules" {
  description = "List of nat rules to apply to firewall."
  type = list(object({
    name     = string,
    priority = number,
    action   = string,
    rules = list(object({
      name                  = string,
      source_addresses      = list(string),
      source_ip_groups      = list(string),
      destination_ports     = list(string),
      destination_addresses = list(string),
      translated_port       = number,
      translated_address    = string,
      protocols             = list(string)
    }))
  }))
  default = null
}

variable "afw_firewall_network_rules" {
  description = "List of network rules to apply to firewall."
  type = list(object({
    name     = string,
    priority = number,
    action   = string,
    rules = list(object({
      name                  = string,
      source_addresses      = list(string),
      source_ip_groups      = list(string),
      destination_ports     = list(string),
      destination_addresses = list(string),
      destination_ip_groups = list(string),
      destination_fqdns     = list(string),
      protocols             = list(string)
    }))
  }))
  default = null
}

variable "afw_firewall_application_rules" {
  description = "Microsoft-managed virtual network that enables connectivity from other resources."
  type = list(object({
    name             = string,
    priority         = number,
    action           = string,
    rules = list(object({
      name             = string,
      source_addresses = list(string),
      source_ip_groups = list(string),
      target_fqdns     = list(string),
      protocols = list(object({
        port = string,
        type = string
      }))
    }))
  }))
  default = null
}

variable "afw_firewall_policy" {
  description = "Manages a Firewall Policy resource that contains NAT, network, and application rule collections, and Threat Intelligence settings."
  type = object({
    sku                      = string
    base_policy_id           = string
    threat_intelligence_mode = string
    dns = object({
      servers       = list(string)
      proxy_enabled = bool
    })
    threat_intelligence_allowlist = object({
      ip_addresses = list(string)
      fqdns        = list(string)
    })
  })
  default = null
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}