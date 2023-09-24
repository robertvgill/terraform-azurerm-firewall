locals {
  public_ip_map = { for pip in var.afw_public_ip_names : pip => true }
}