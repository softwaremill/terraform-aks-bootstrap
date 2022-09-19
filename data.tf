# This group have to be created manually
data "azuread_group" "aks_cluster_admins" {
  count        = var.use_cluster_admins_group ? 1 : 0
  display_name = var.admins_group_name
}

data "azuread_client_config" "current" {}
