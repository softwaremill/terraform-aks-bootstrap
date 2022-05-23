# Terraform AKS module

This module creates AKS cluster with network dependency. 

## Usage

The easiest way to use this repository is to create module like in example below:

```hcl
module "aks" {
  source                         = "../../"
  cluster_name                   = "test-aks"
  prefix                         = "test"
  resource_group_name            = "test-group"
  address_space                  = "10.0.0.0/16"
  subnet_prefixes                = ["10.0.0.0/20", "10.0.16.0/20", "10.0.32.0/20"]
  subnet_names                   = ["subnet1", "subnet2", "subnet3"]
  net_profile_service_cidr       = "10.3.0.0/20"
  net_profile_docker_bridge_cidr = "170.10.0.1/16"
  net_profile_dns_service_ip     = "10.3.0.10"
  cluster_sku_tier               = "Paid"
  registry_sku_tier              = "Basic"
  agents_size                    = "standard_d4s_v3"
  agents_count                   = 3
  agents_max_count               = 4
  agents_min_count               = 3
  enable_auto_scaling            = false
  kubernetes_version             = "1.22.2"
  orchestrator_version           = "1.22.2"
  use_cluster_admins_group       = true
}
```

Because of bug in API azure active directlry group for administrators have to be created manually 
Please see below declaration and create it manually:

```hcl
resource "azuread_group" "aks_cluster_admins" {
  display_name     = "AKS-cluster-admins"
  owners           = [data.azuread_client_config.current.object_id]
  security_enabled = true
}
```

We are using this resource with data object:

```hcl
data "azuread_group" "aks_cluster_admins" {
  count = var.use_cluster_admins_group ? 1 : 0
  display_name = var.admins_group_name
}
```
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | n/a |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aks"></a> [aks](#module\_aks) | Azure/aks/azurerm | n/a |
| <a name="module_network"></a> [network](#module\_network) | Azure/network/azurerm | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_container_registry.acr](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_registry) | resource |
| [azurerm_resource_group.cluster](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.aks_to_acr](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azuread_client_config.current](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/client_config) | data source |
| [azuread_group.aks_cluster_admins](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_address_space"></a> [address\_space](#input\_address\_space) | The list of the address spaces that is used by the virtual network. | `string` | n/a | yes |
| <a name="input_admins_group_name"></a> [admins\_group\_name](#input\_admins\_group\_name) | Group name for AKS admins | `string` | `"AKS-cluster-admins"` | no |
| <a name="input_agents_count"></a> [agents\_count](#input\_agents\_count) | The number of Agents that should exist in the Agent Pool. Please set `agents_count` `null` while `enable_auto_scaling` is `true` to avoid possible `agents_count` changes. | `number` | n/a | yes |
| <a name="input_agents_max_count"></a> [agents\_max\_count](#input\_agents\_max\_count) | Maximum number of nodes in a pool | `number` | n/a | yes |
| <a name="input_agents_max_pods"></a> [agents\_max\_pods](#input\_agents\_max\_pods) | The maximum number of pods that can run on each agent. Changing this forces a new resource to be created. | `number` | `100` | no |
| <a name="input_agents_min_count"></a> [agents\_min\_count](#input\_agents\_min\_count) | Minimum number of nodes in a pool | `number` | n/a | yes |
| <a name="input_agents_size"></a> [agents\_size](#input\_agents\_size) | The default virtual machine size for the Kubernetes agents | `string` | `"Standard_D2s_v3"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Cluster name | `string` | n/a | yes |
| <a name="input_cluster_sku_tier"></a> [cluster\_sku\_tier](#input\_cluster\_sku\_tier) | Description: The SKU Tier that should be used for this Kubernetes Cluster. Possible values are Free and Paid | `string` | `"Paid"` | no |
| <a name="input_enable_auto_scaling"></a> [enable\_auto\_scaling](#input\_enable\_auto\_scaling) | Enable node pool autoscaling | `bool` | `false` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Specify which Kubernetes release to use. The default used is the latest Kubernetes version available in the region | `string` | `"1.19.3"` | no |
| <a name="input_net_profile_dns_service_ip"></a> [net\_profile\_dns\_service\_ip](#input\_net\_profile\_dns\_service\_ip) | IP address within the Kubernetes service address range that will be used by cluster service discovery (kube-dns). Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_net_profile_docker_bridge_cidr"></a> [net\_profile\_docker\_bridge\_cidr](#input\_net\_profile\_docker\_bridge\_cidr) | IP address (in CIDR notation) used as the Docker bridge IP address on nodes. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_net_profile_service_cidr"></a> [net\_profile\_service\_cidr](#input\_net\_profile\_service\_cidr) | The Network Range used by the Kubernetes service. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_orchestrator_version"></a> [orchestrator\_version](#input\_orchestrator\_version) | Specify which Kubernetes release to use for the orchestration layer. The default used is the latest Kubernetes version available in the region | `string` | `"1.19.3"` | no |
| <a name="input_os_disk_size_gb"></a> [os\_disk\_size\_gb](#input\_os\_disk\_size\_gb) | Disk size of nodes in GBs. | `number` | `50` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | The prefix for the resources created in the specified Azure Resource Group | `string` | n/a | yes |
| <a name="input_registry_name"></a> [registry\_name](#input\_registry\_name) | Override default name for azure container registry | `string` | `null` | no |
| <a name="input_registry_sku_tier"></a> [registry\_sku\_tier](#input\_registry\_sku\_tier) | Basic | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Resource group name | `string` | n/a | yes |
| <a name="input_subnet_names"></a> [subnet\_names](#input\_subnet\_names) | A list of public subnets inside the vNet. | `list(string)` | n/a | yes |
| <a name="input_subnet_prefixes"></a> [subnet\_prefixes](#input\_subnet\_prefixes) | The address prefix to use for the subnet. | `list(string)` | n/a | yes |
| <a name="input_use_cluster_admins_group"></a> [use\_cluster\_admins\_group](#input\_use\_cluster\_admins\_group) | Enable if group AKS-cluster-admins is created | `bool` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | n/a |
| <a name="output_container_registry_name"></a> [container\_registry\_name](#output\_container\_registry\_name) | n/a |
| <a name="output_registry_name"></a> [registry\_name](#output\_registry\_name) | n/a |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | n/a |
