variable "cluster_name" {
  type        = string
  description = "Cluster name"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "prefix" {
  type        = string
  description = "The prefix for the resources created in the specified Azure Resource Group"
}

variable "cluster_sku_tier" {
  type        = string
  description = "Description: The SKU Tier that should be used for this Kubernetes Cluster. Possible values are Free and Paid"
  default     = "Paid"
}

variable "address_space" {
  type        = string
  description = "The list of the address spaces that is used by the virtual network."
}

variable "subnet_prefixes" {
  type        = list(string)
  description = "The address prefix to use for the subnet."
}

variable "subnet_names" {
  type        = list(string)
  description = "A list of public subnets inside the vNet."
}

variable "enable_auto_scaling" {
  type        = bool
  description = "Enable node pool autoscaling"
  default     = false
}

variable "agents_min_count" {
  type        = number
  description = "Minimum number of nodes in a pool"
}

variable "agents_max_count" {
  type        = number
  description = "Maximum number of nodes in a pool"
}

variable "agents_count" {
  type        = number
  description = "The number of Agents that should exist in the Agent Pool. Please set `agents_count` `null` while `enable_auto_scaling` is `true` to avoid possible `agents_count` changes."
}

variable "agents_size" {
  default     = "Standard_D2s_v3"
  description = "The default virtual machine size for the Kubernetes agents"
  type        = string
}

variable "kubernetes_version" {
  type        = string
  description = "Specify which Kubernetes release to use. The default used is the latest Kubernetes version available in the region"
  default     = "1.19.3"
}

variable "orchestrator_version" {
  type        = string
  description = "Specify which Kubernetes release to use for the orchestration layer. The default used is the latest Kubernetes version available in the region"
  default     = "1.19.3"
}

variable "registry_sku_tier" {
  type        = string
  description = "Basic"
}

variable "os_disk_size_gb" {
  type        = number
  description = "Disk size of nodes in GBs."
  default     = 50
}

variable "agents_max_pods" {
  type        = number
  description = "The maximum number of pods that can run on each agent. Changing this forces a new resource to be created."
  default     = 100
}

variable "net_profile_dns_service_ip" {
  description = "IP address within the Kubernetes service address range that will be used by cluster service discovery (kube-dns). Changing this forces a new resource to be created."
  type        = string
}

variable "net_profile_docker_bridge_cidr" {
  description = "IP address (in CIDR notation) used as the Docker bridge IP address on nodes. Changing this forces a new resource to be created."
  type        = string
}

variable "net_profile_service_cidr" {
  description = "The Network Range used by the Kubernetes service. Changing this forces a new resource to be created."
  type        = string
}

variable "use_cluster_admins_group" {
  description = "Enable if group AKS-cluster-admins is created"
  type        = bool
}

variable "registry_name" {
  description = "Override default name for azure container registry"
  type        = string
  default     = null
}

variable "admins_group_name" {
  description = "Group name for AKS admins"
  type        = string
  default     = "AKS-cluster-admins"
}

variable "private_cluster_enabled" {
  description = "Create private cluster"
  default     = true
}

variable "agents_labels" {
  description = "(Optional) A map of Kubernetes labels which should be applied to nodes in the Default Node Pool. Changing this forces a new resource to be created."
  type        = map(string)
  default = {
    "nodepool" : "defaultnodepool"
  }
}

variable "agents_tags" {
  description = "(Optional) A mapping of tags to assign to the Node Pool."
  type        = map(string)
  default = {
    "Agent" : "defaultnodepoolagent"
  }
}
