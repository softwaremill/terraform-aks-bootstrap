include "root" {
  path = find_in_parent_folders()
}
inputs = {
  source                         = "../../"
  cluster_name                   = "Aks"
  registry_name                  = "AksSoftwareMillRegistry"
  prefix                         = "test"
  resource_group_name            = "test-group"
  private_cluster_enabled        = false
  address_space                  = "10.0.0.0/16"
  subnet_prefixes                = ["10.0.0.0/20", "10.0.16.0/20", "10.0.32.0/20"]
  subnet_names                   = ["subnet1", "subnet2", "subnet3"]
  net_profile_service_cidr       = "10.3.0.0/20"
  net_profile_docker_bridge_cidr = "170.10.0.1/16"
  net_profile_dns_service_ip     = "10.3.0.10"
  cluster_sku_tier               = "Paid"
  registry_sku_tier              = "Basic"
  agents_size                    = "standard_d4s_v3"
  agents_count                   = 1
  agents_max_count               = 3
  agents_min_count               = 1
  enable_auto_scaling            = true
  kubernetes_version             = "1.24.3"
  orchestrator_version           = "1.24.3"
  use_cluster_admins_group       = false
  agents_labels = {
    "node-group" = "controllers"
  }

  agents_tags = {
    "environment" = "dev"
  }

  node_pools = {
    "queues" = {
      enable_auto_scaling = true
      min_count    = 1
      max_count    = 3
      vm_size             = "standard_d4s_v3"
      node_labels = {
        "node-group" = "queues"
      }
      tags = {
        "environment" = "dev"
      }
    }
  }
}
