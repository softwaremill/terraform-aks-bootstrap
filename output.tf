output "cluster_name" {
  description = "The aurerm_kubernetes-cluster's name."
  value       = var.cluster_name
}

output "cluster_id" {
  description = "The azurerm_kubernetes_cluster's id."
  value       = module.aks.aks_id
}

output "host" {
  description = "The host in the azurerm_kubernetes_cluster's kube_config block. The Kubernetes cluster server host."
  value       = module.aks.host
}

output "kubernetes_ca_certificate" {
  description = "The cluster_ca_certificate in the azurerm_kubernetes_cluster's kube_admin_config block. Base64 encoded public CA certificate used as the root of trust for the Kubernetes cluster."
  value       = module.aks.admin_cluster_ca_certificate
}

output "resource_group_name" {
  value = var.resource_group_name
}

output "container_registry_name" {
  value = local.registry_name
}

output "registry_name" {
  value = var.registry_name
}
