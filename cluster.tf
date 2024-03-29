resource "azurerm_resource_group" "cluster" {
  name     = var.resource_group_name
  location = "West Europe"
  tags     = var.resource_group_tags
}

module "aks" {
  source                          = "Azure/aks/azurerm"
  version                         = "6.5.0"
  resource_group_name             = azurerm_resource_group.cluster.name
  client_id                       = ""
  client_secret                   = ""
  kubernetes_version              = var.kubernetes_version
  orchestrator_version            = var.orchestrator_version
  cluster_name                    = var.cluster_name
  prefix                          = var.prefix
  network_plugin                  = "azure"
  vnet_subnet_id                  = module.network.vnet_subnets[0]
  os_disk_size_gb                 = var.os_disk_size_gb
  sku_tier                        = var.cluster_sku_tier
  rbac_aad_admin_group_object_ids = var.use_cluster_admins_group ? [data.azuread_group.aks_cluster_admins[0].id] : null
  rbac_aad_managed                = true
  private_cluster_enabled         = var.private_cluster_enabled
  enable_auto_scaling             = var.enable_auto_scaling
  enable_host_encryption          = var.enable_host_encryption
  agents_size                     = var.agents_size
  agents_min_count                = var.agents_min_count
  agents_max_count                = var.agents_max_count
  agents_count                    = var.agents_count # Please set `agents_count` `null` while `enable_auto_scaling` is `true` to avoid possible `agents_count` changes.
  agents_max_pods                 = 100
  agents_pool_name                = "default"
  agents_availability_zones       = ["1", "2", "3"]
  agents_type                     = "VirtualMachineScaleSets"

  agents_labels = var.agents_labels
  agents_tags   = var.agents_tags
  tags          = var.cluster_tags


  network_policy                 = "azure"
  net_profile_dns_service_ip     = var.net_profile_dns_service_ip
  net_profile_docker_bridge_cidr = var.net_profile_docker_bridge_cidr
  net_profile_service_cidr       = var.net_profile_service_cidr

  depends_on = [module.network]
}

# Because of bug in API this resource have to be created manually
#resource "azuread_group" "aks_cluster_admins" {
#  display_name     = "AKS-cluster-admins"
#  owners           = [data.azuread_client_config.current.object_id]
#  security_enabled = true
#}

resource "azurerm_role_assignment" "aks_to_acr" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = module.aks.kubelet_identity[0].object_id
}

resource "azurerm_kubernetes_cluster_node_pool" "node_pools" {
  for_each              = var.node_pools
  name                  = each.key
  kubernetes_cluster_id = module.aks.aks_id
  vm_size               = each.value.vm_size
  enable_auto_scaling   = each.value.enable_auto_scaling
  node_count            = each.value.node_count # Please set `agents_count` `null` while `enable_auto_scaling` is `true` to avoid possible `agents_count` changes.
  min_count             = each.value.min_count
  max_count             = each.value.max_count
  node_labels           = each.value.node_labels
  tags                  = each.value.node_tags
}
