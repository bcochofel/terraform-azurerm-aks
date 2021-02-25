variable "resource_group_name" {
  description = <<EOT
The name of the resource group in which to create the AKS.
The Resource Group must already exist.
EOT
  type        = string
}

variable "public_ssh_key" {
  description = <<EOT
The Public SSH Key used to access the cluster.
Changing this forces a new resource to be created.
EOT
  type        = string
  default     = ""
}

variable "name" {
  description = <<EOT
The name of the Managed Kubernetes Cluster to create.
Changing this forces a new resource to be created.
EOT
  type        = string

  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 63 && can(regex("^[a-zA-Z0-9][a-zA-Z0-9-_.]+[a-zA-Z0-9]$", var.name))
    error_message = "Invalid name (check Azure Resource naming restrictions for more info)."
  }
}

variable "dns_prefix" {
  description = <<EOT
DNS prefix specified when creating the managed cluster.
Changing this forces a new resource to be created.
EOT
  type        = string
}

# start - default_node_pool block variables

variable "default_pool_name" {
  description = <<EOT
The name which should be used for the default Kubernetes Node Pool.
Changing this forces a new resource to be created.
EOT
  type        = string

  validation {
    condition     = length(var.default_pool_name) >= 1 && length(var.default_pool_name) <= 12 && can(regex("^[a-z][a-z0-9]+[a-z0-9]$", var.default_pool_name))
    error_message = "Invalid node pool name (check Azure Resource naming restrictions for more info)."
  }
}

variable "vm_size" {
  description = "The size of the Virtual Machine, such as Standard_DS2_v2."
  type        = string
  default     = "Standard_D2s_v3"
}

variable "availability_zones" {
  description = <<EOT
A list of Availability Zones across which the Node Pool should be spread.
Changing this forces a new resource to be created.
This requires that the type is set to VirtualMachineScaleSets and that
load_balancer_sku is set to Standard.
EOT
  type        = list(string)
  default     = null
}

variable "enable_auto_scaling" {
  description = <<EOT
Should the Kubernetes Auto Scaler be enabled for this Node Pool?
This requires that the type is set to VirtualMachineScaleSets.
EOT
  type        = bool
  default     = false
}

variable "enable_host_encryption" {
  description = <<EOT
Should the nodes in the Default Node Pool have host encryption enabled?
EOT
  type        = bool
  default     = false
}

variable "enable_node_public_ip" {
  description = <<EOT
Should nodes in this Node Pool have a Public IP Address?
EOT
  type        = bool
  default     = false
}

variable "max_pods" {
  description = <<EOT
The maximum number of pods that can run on each agent.
Changing this forces a new resource to be created.
EOT
  type        = number
  default     = null
}

variable "node_labels" {
  description = <<EOT
A map of Kubernetes labels which should be applied to nodes in the Default Node Pool.
Changing this forces a new resource to be created.
EOT
  type        = map(string)
  default     = {}
}

variable "only_critical_addons_enabled" {
  description = <<EOT
Enabling this option will taint default node pool with
CriticalAddonsOnly=true:NoSchedule taint.
Changing this forces a new resource to be created.
EOT
  type        = bool
  default     = false
}

variable "orchestrator_version" {
  description = <<EOT
Version of Kubernetes used for the Agents. If not specified, the latest
recommended version will be used at provisioning time (but won't auto-upgrade)
EOT
  type        = string
  default     = null
}

variable "os_disk_size_gb" {
  description = <<EOT
The size of the OS Disk which should be used for each agent in the Node Pool.
Changing this forces a new resource to be created.
EOT
  type        = number
  default     = null
}

variable "os_disk_type" {
  description = <<EOT
The type of disk which should be used for the Operating System.
Possible values are Ephemeral and Managed.
Changing this forces a new resource to be created.
EOT
  type        = string
  default     = "Managed"
}

variable "agent_type" {
  description = <<EOT
The type of Node Pool which should be created.
Possible values are AvailabilitySet and VirtualMachineScaleSets.
EOT
  type        = string
  default     = "VirtualMachineScaleSets"
}

variable "agent_tags" {
  description = "A mapping of tags to assign to the Node Pool."
  type        = map(string)
  default     = {}
}

variable "vnet_subnet_id" {
  description = <<EOT
The ID of a Subnet where the Kubernetes Node Pool should exist.
Changing this forces a new resource to be created.
EOT
  type        = string
  default     = null
}

variable "max_count" {
  description = <<EOT
The maximum number of nodes which should exist in this Node Pool.
If specified this must be between 1 and 1000.
EOT
  type        = number
  default     = null
}

variable "min_count" {
  description = <<EOT
The minimum number of nodes which should exist in this Node Pool.
If specified this must be between 1 and 1000.
EOT
  type        = number
  default     = null
}

variable "node_count" {
  description = <<EOT
The initial number of nodes which should exist in this Node Pool. If specified
this must be between 1 and 1000 and between min_count and max_count.
EOT
  type        = number
  default     = null
}

variable "max_surge" {
  description = <<EOT
The maximum number or percentage of nodes which will be added to the Node Pool
size during an upgrade.
If a percentage is provided, the number of surge nodes is calculated from the
node_count value on the current cluster. Node surge can allow a cluster to
have more nodes than max_count during an upgrade.
EOT
  type        = string
  default     = null
}

# end - default_node_pool block variables

variable "kubernetes_version" {
  description = <<EOT
Version of Kubernetes specified when creating the AKS managed cluster.
If not specified, the latest recommended version will be used at provisioning time (but won't auto-upgrade).
EOT
  type        = string
  default     = null
}
