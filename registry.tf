resource "azurerm_container_registry" "acr" {
  name                = var.registry_name == null ? local.registry_name : var.registry_name
  resource_group_name = azurerm_resource_group.cluster.name
  location            = azurerm_resource_group.cluster.location
  sku                 = var.registry_sku_tier
  admin_enabled       = false
}
