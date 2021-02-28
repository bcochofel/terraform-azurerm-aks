variable "kubernetes_cluster_id" {
  description = <<EOT
The ID of the Kubernetes Cluster where this Node Pool should exist.
Changing this forces a new resource to be created.
The type of Default Node Pool for the Kubernetes Cluster must be
VirtualMachineScaleSets to attach multiple node pools.
EOT
  type        = string
}

variable "vnet_subnet_id" {
  description = <<EOT
The ID of the Subnet where this Node Pool should exist.
At this time the vnet_subnet_id must be the same for all node pools in the cluster.
EOT
  type        = string
  default     = null
}

variable "vm_size" {
  description = <<EOT
The SKU which should be used for the Virtual Machines used in this Node Pool.
Changing this forces a new resource to be created.
EOT
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

variable "eviction_policy" {
  description = <<EOT
The Eviction Policy which should be used for Virtual Machines within the Virtual
Machine Scale Set powering this Node Pool.
Possible values are Deallocate and Delete.
Changing this forces a new resource to be created.
EOT
  type        = string
  default     = "Delete"
}

variable "max_pods" {
  description = <<EOT
The maximum number of pods that can run on each agent.
Changing this forces a new resource to be created.
EOT
  type        = number
  default     = null
}

variable "mode" {
  description = <<EOT
Should this Node Pool be used for System or User resources?
Possible values are System and User.
EOT
  type        = string
  default     = "User"
}

variable "node_labels" {
  description = <<EOT
A map of Kubernetes labels which should be applied to nodes in the Default Node Pool.
Changing this forces a new resource to be created.
EOT
  type        = map(string)
  default     = {}
}

variable "node_taints" {
  description = <<EOT
A list of Kubernetes taints which should be applied to nodes in the agent pool
(e.g key=value:NoSchedule). Changing this forces a new resource to be created.
EOT
  type        = list(string)
  default     = null
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

variable "os_type" {
  description = <<EOT
The Operating System which should be used for this Node Pool. Changing this
forces a new resource to be created. Possible values are Linux and Windows.
EOT
  type        = string
  default     = "Linux"
}

variable "priority" {
  description = <<EOT
The Priority for Virtual Machines within the Virtual Machine Scale Set that
powers this Node Pool. Possible values are Regular and Spot.
Changing this forces a new resource to be created.
EOT
  type        = string
  default     = "Regular"
}

variable "spot_max_price" {
  description = <<EOT
The maximum price you're willing to pay in USD per Virtual Machine.
Valid values are -1 (the current on-demand price for a Virtual Machine) or a
positive value with up to five decimal places.
Changing this forces a new resource to be created.
EOT
  type        = number
  default     = null
}

variable "tags" {
  description = "A mapping of tags which should be assigned to Resource."
  type        = map(string)
  default     = {}
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
  default     = 0
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

variable "node_pools" {
  description = <<EOT
Allows to create multiple Node Pools.

node_pools can have more than one pool. The name attribute is used
to create key/value map, and priority is needed to filter, but all the other
elements are optional.

```hcl
node_pools = [
  {
    name = "user1"
    priority = "Regular"
  },
  {
    name = "spot1"
    priority = "Spot"
  }
]
```

Valid fields are:

* vm_size
* availability_zones
* enable_auto_scaling
* enable_host_encryption
* enable_node_public_ip
* eviction_policy
* max_pods
* mode
* node_labels
* node_taints
* orchestrator_version
* os_disk_size_gb
* os_disk_type
* os_type
* priority
* spto_max_price
* tags
* max_count
* min_count
* node_count
* max_surge
EOT
  type        = any
  default     = []
}
