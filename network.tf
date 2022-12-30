module "network" {
  source              = "Azure/network/azurerm"
  version             = "~> 5.0"
  resource_group_name = azurerm_resource_group.cluster.name
  use_for_each        = var.use_for_each
  address_space       = var.address_space
  subnet_prefixes     = var.subnet_prefixes
  subnet_names        = var.subnet_names
  depends_on          = [azurerm_resource_group.cluster]
}
