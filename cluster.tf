resource "azurerm_resource_group" "cluster" {
  name     = var.resource_group_name
  location = "West Europe"
}

module "aks" {
  source                           = "Azure/aks/azurerm"
  resource_group_name              = azurerm_resource_group.cluster.name
  client_id                        = ""
  client_secret                    = ""
  kubernetes_version               = var.kubernetes_version
  orchestrator_version             = var.orchestrator_version
  cluster_name                     = var.cluster_name
  prefix                           = var.prefix
  network_plugin                   = "azure"
  vnet_subnet_id                   = module.network.vnet_subnets[0]
  os_disk_size_gb                  = var.os_disk_size_gb
  sku_tier                         = var.cluster_sku_tier
  enable_role_based_access_control = true
  rbac_aad_admin_group_object_ids  = var.use_cluster_admins_group ? [data.azuread_group.aks_cluster_admins[0].id] : null
  rbac_aad_managed                 = true
  private_cluster_enabled          = false
  enable_http_application_routing  = true
  enable_azure_policy              = true
  enable_auto_scaling              = var.enable_auto_scaling
  enable_host_encryption           = true
  agents_size                      = var.agents_size
  agents_min_count                 = var.agents_min_count
  agents_max_count                 = var.agents_max_count
  agents_count                     = var.agents_count # Please set `agents_count` `null` while `enable_auto_scaling` is `true` to avoid possible `agents_count` changes.
  agents_max_pods                  = 100
  agents_pool_name                 = "default"
  agents_availability_zones        = ["1", "2", "3"]
  agents_type                      = "VirtualMachineScaleSets"

  agents_labels = {
    "nodepool" : "defaultnodepool"
  }

  agents_tags = {
    "Agent" : "defaultnodepoolagent"
  }

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
