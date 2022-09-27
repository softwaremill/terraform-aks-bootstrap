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
  sensitive   = true
  value       = module.aks.host
}

output "client_certificate" {
  description = "The `client_certificate` in the `azurerm_kubernetes_cluster`'s `kube_config` block. Base64 encoded public certificate used by clients to authenticate to the Kubernetes cluster."
  sensitive   = true
  value       = module.aks.client_certificate
}

output "client_key" {
  description = "The `client_key` in the `azurerm_kubernetes_cluster`'s `kube_config` block. Base64 encoded private key used by clients to authenticate to the Kubernetes cluster."
  sensitive   = true
  value       = module.aks.client_key
}

output "cluster_ca_certificate" {
  description = "The `cluster_ca_certificate` in the `azurerm_kubernetes_cluster`'s `kube_config` block. Base64 encoded public CA certificate used as the root of trust for the Kubernetes cluster."
  sensitive   = true
  value       = module.aks.cluster_ca_certificate
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
