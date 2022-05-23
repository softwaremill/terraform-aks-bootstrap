module "network" {
  source              = "Azure/network/azurerm"
  resource_group_name = azurerm_resource_group.cluster.name
  address_space       = var.address_space
  subnet_prefixes     = var.subnet_prefixes
  subnet_names        = var.subnet_names
  depends_on          = [azurerm_resource_group.cluster]
}
