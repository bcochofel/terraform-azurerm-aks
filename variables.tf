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

  validation {
    condition     = length(var.dns_prefix) >= 3 && length(var.dns_prefix) <= 45 && can(regex("^[a-zA-Z][a-zA-Z0-9-]+[a-zA-Z0-9]$", var.dns_prefix))
    error_message = "The dns_prefix must contain between 3 and 45 characters, and can contain only letters, numbers, and hyphens. It must start with a letter and must end with a letter or a number."
  }
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
  default     = 1
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

variable "admin_username" {
  description = <<EOT
The Admin Username for the Cluster.
Changing this forces a new resource to be created.
EOT
  type        = string
  default     = "azureuser"
}

# end - default_node_pool block variables

# start - identity/service_principal

variable "user_assigned_identity_id" {
  description = "The ID of a user assigned identity."
  type        = string
  default     = ""
}

# end - identity/service_principal

# start - addon_profile

# aci_connector_linux

variable "enable_aci_connector_linux" {
  description = "Is the virtual node addon enabled?"
  type        = bool
  default     = false
}

variable "aci_connector_linux_subnet_name" {
  description = <<EOT
The subnet name for the virtual nodes to run.
AKS will add a delegation to the subnet named here.
To prevent further runs from failing you should make sure that the subnet
you create for virtual nodes has a delegation, like so.

```hcl
resource "azurerm_subnet" "virtual" {

  #...

  delegation {
    name = "aciDelegation"
    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}
```
EOT
  type        = string
  default     = null
}

# azure_policy

variable "enable_azure_policy" {
  description = "Is the Azure Policy for Kubernetes Add On enabled?"
  type        = bool
  default     = false
}

# http_application_routing

variable "enable_http_application_routing" {
  description = "Is HTTP Application Routing Enabled?"
  type        = bool
  default     = false
}

# kube_dashboard

variable "enabled_kube_dashboard" {
  description = "Is the Kubernetes Dashboard enabled?"
  type        = bool
  default     = false
}

# oms_agent

variable "enable_log_analytics_workspace" {
  description = <<EOT
Enable the creation of azurerm_log_analytics_workspace and
azurerm_log_analytics_solution or not
EOT
  type        = bool
  default     = false
}

variable "log_analytics_workspace_sku" {
  description = <<EOT
The SKU (pricing level) of the Log Analytics workspace.
For new subscriptions the SKU should be set to PerGB2018
EOT
  type        = string
  default     = "PerGB2018"
}

variable "log_retention_in_days" {
  description = "The retention period for the logs in days"
  type        = number
  default     = 30
}

# end - addon_profile

# start - role based access control

variable "enable_role_based_access_control" {
  description = <<EOT
Is Role Based Access Control Enabled?
Changing this forces a new resource to be created.
EOT
  type        = bool
  default     = true
}

variable "enable_azure_active_directory" {
  description = "Enable Azure Active Directory Integration?"
  type        = bool
  default     = false
}

variable "rbac_aad_managed" {
  description = <<EOT
Is the Azure Active Directory integration Managed, meaning that Azure will
create/manage the Service Principal used for integration.
EOT
  type        = bool
  default     = false
}

variable "rbac_aad_admin_group_object_ids" {
  description = "Object ID of groups with admin access."
  type        = list(string)
  default     = null
}

variable "rbac_aad_client_app_id" {
  description = "The Client ID of an Azure Active Directory Application."
  type        = string
  default     = null
}

variable "rbac_aad_server_app_id" {
  description = "The Server ID of an Azure Active Directory Application."
  type        = string
  default     = null
}

variable "rbac_aad_server_app_secret" {
  description = "The Server Secret of an Azure Active Directory Application."
  type        = string
  default     = null
}

# end - role based access control

# start - network profile

variable "network_plugin" {
  description = <<EOT
Network plugin to use for networking. Currently supported values are azure and kubenet.
Changing this forces a new resource to be created.
EOT
  type        = string
  default     = "kubenet"
}

variable "network_policy" {
  description = <<EOT
Sets up network policy to be used with Azure CNI.
Currently supported values are calico and azure.
Changing this forces a new resource to be created.
EOT
  type        = string
  default     = null
}

variable "dns_service_ip" {
  description = <<EOT
IP address within the Kubernetes service address range that will be used by
cluster service discovery (kube-dns).
Changing this forces a new resource to be created.
EOT
  type        = string
  default     = null
}

variable "docker_bridge_cidr" {
  description = <<EOT
IP address (in CIDR notation) used as the Docker bridge IP address on nodes.
Changing this forces a new resource to be created.
EOT
  type        = string
  default     = null
}

variable "outbound_type" {
  description = <<EOT
The outbound (egress) routing method which should be used for this Kubernetes
Cluster. Possible values are loadBalancer and userDefinedRouting.
EOT
  type        = string
  default     = "loadBalancer"
}

variable "pod_cidr" {
  description = <<EOT
The CIDR to use for pod IP addresses. This field can only be set when
network_plugin is set to kubenet.
Changing this forces a new resource to be created.
EOT
  type        = string
  default     = null
}

variable "service_cidr" {
  description = <<EOT
The Network Range used by the Kubernetes service.
Changing this forces a new resource to be created.
EOT
  type        = string
  default     = null
}

variable "load_balancer_sku" {
  description = <<EOT
Specifies the SKU of the Load Balancer used for this Kubernetes Cluster.
Possible values are Basic and Standard.
EOT
  type        = string
  default     = "Standard"
}

# end - network profile

variable "automatic_channel_upgrade" {
  description = <<EOT
The upgrade channel for this Kubernetes Cluster.
Possible values are none, patch, rapid, and stable.
Cluster Auto-Upgrade will update the Kubernetes Cluster (and it's Node Pools)
to the latest GA version of Kubernetes automatically.
Please see [the Azure documentation for more information](https://docs.microsoft.com/en-us/azure/aks/upgrade-cluster#set-auto-upgrade-channel-preview).
EOT
  type        = string
  default     = null
}

variable "api_server_authorized_ip_ranges" {
  description = "The IP ranges to whitelist for incoming traffic to the masters."
  type        = list(string)
  default     = null
}

variable "disk_encryption_set_id" {
  description = <<EOT
(Optional) The ID of the Disk Encryption Set which should be used for the Nodes and Volumes.
Please see [the documentation](https://docs.microsoft.com/en-us/azure/aks/azure-disk-customer-managed-keys)
and [disk_encryption_set](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/disk_encryption_set)
for more information.
EOT
  type        = string
  default     = null
}

variable "kubernetes_version" {
  description = <<EOT
Version of Kubernetes specified when creating the AKS managed cluster.
If not specified, the latest recommended version will be used at provisioning time (but won't auto-upgrade).
EOT
  type        = string
  default     = null
}

variable "node_resource_group" {
  description = <<EOT
The name of the Resource Group where the Kubernetes Nodes should exist.
Changing this forces a new resource to be created.
Azure requires that a new, non-existent Resource Group is used, as otherwise the
provisioning of the Kubernetes Service will fail.
EOT
  type        = string
  default     = null
}

variable "private_cluster_enabled" {
  description = <<EOT
Should this Kubernetes Cluster have its API server only exposed on internal
IP addresses? This provides a Private IP Address for the Kubernetes API on the
Virtual Network where the Kubernetes Cluster is located.
Changing this forces a new resource to be created.
EOT
  type        = bool
  default     = false
}

variable "sku_tier" {
  description = <<EOT
The SKU Tier that should be used for this Kubernetes Cluster.
Possible values are Free and Paid (which includes the Uptime SLA).
EOT
  type        = string
  default     = "Free"
}

variable "private_dns_zone_id" {
  description = <<EOT
Either the ID of Private DNS Zone which should be delegated to this Cluster,
or System to have AKS manage this.
If you use BYO DNS Zone, AKS cluster should either use a User Assigned Identity
or a service principal (which is deprecated) with the Private DNS Zone Contributor
role and access to this Private DNS Zone. If UserAssigned identity is used - to
prevent improper resource order destruction - cluster should depend on the role assignment
EOT
  type        = string
  default     = null
}

variable "tags" {
  description = "A mapping of tags which should be assigned to Resources."
  type        = map(string)
  default     = {}
}

variable "enable_attach_acr" {
  description = "Enable ACR Pull attach. Needs acr_id to be defined."
  type        = bool
  default     = false
}

variable "acr_id" {
  description = "Attach ACR ID to allow ACR Pull from the SP/Managed Indentity."
  type        = string
  default     = ""
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
