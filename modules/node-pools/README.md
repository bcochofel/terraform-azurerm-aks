# node-pools

Module to handle AKS Node Pools.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| azurerm | n/a |

## Modules

No Modules.

## Resources

| Name |
|------|
| [azurerm_kubernetes_cluster_node_pool](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster_node_pool) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| availability\_zones | A list of Availability Zones across which the Node Pool should be spread.<br>Changing this forces a new resource to be created.<br>This requires that the type is set to VirtualMachineScaleSets and that<br>load\_balancer\_sku is set to Standard. | `list(string)` | `null` | no |
| enable\_auto\_scaling | Should the Kubernetes Auto Scaler be enabled for this Node Pool?<br>This requires that the type is set to VirtualMachineScaleSets. | `bool` | `false` | no |
| enable\_host\_encryption | Should the nodes in the Default Node Pool have host encryption enabled? | `bool` | `false` | no |
| enable\_node\_public\_ip | Should nodes in this Node Pool have a Public IP Address? | `bool` | `false` | no |
| eviction\_policy | The Eviction Policy which should be used for Virtual Machines within the Virtual<br>Machine Scale Set powering this Node Pool.<br>Possible values are Deallocate and Delete.<br>Changing this forces a new resource to be created. | `string` | `"Delete"` | no |
| kubernetes\_cluster\_id | The ID of the Kubernetes Cluster where this Node Pool should exist.<br>Changing this forces a new resource to be created.<br>The type of Default Node Pool for the Kubernetes Cluster must be<br>VirtualMachineScaleSets to attach multiple node pools. | `string` | n/a | yes |
| max\_count | The maximum number of nodes which should exist in this Node Pool.<br>If specified this must be between 1 and 1000. | `number` | `null` | no |
| max\_pods | The maximum number of pods that can run on each agent.<br>Changing this forces a new resource to be created. | `number` | `null` | no |
| max\_surge | The maximum number or percentage of nodes which will be added to the Node Pool<br>size during an upgrade.<br>If a percentage is provided, the number of surge nodes is calculated from the<br>node\_count value on the current cluster. Node surge can allow a cluster to<br>have more nodes than max\_count during an upgrade. | `string` | `null` | no |
| min\_count | The minimum number of nodes which should exist in this Node Pool.<br>If specified this must be between 1 and 1000. | `number` | `null` | no |
| mode | Should this Node Pool be used for System or User resources?<br>Possible values are System and User. | `string` | `"User"` | no |
| node\_count | The initial number of nodes which should exist in this Node Pool. If specified<br>this must be between 1 and 1000 and between min\_count and max\_count. | `number` | `0` | no |
| node\_labels | A map of Kubernetes labels which should be applied to nodes in the Default Node Pool.<br>Changing this forces a new resource to be created. | `map(string)` | `{}` | no |
| node\_pools | Allows to create multiple Node Pools.<br><br>node\_pools can have more than one pool. The name attribute is used<br>to create key/value map, and priority is needed to filter, but all the other<br>elements are optional.<pre>hcl<br>node_pools = [<br>  {<br>    name = "user1"<br>    priority = "Regular"<br>  },<br>  {<br>    name = "spot1"<br>    priority = "Spot"<br>  }<br>]</pre>Valid fields are:<br><br>* vm\_size<br>* availability\_zones<br>* enable\_auto\_scaling<br>* enable\_host\_encryption<br>* enable\_node\_public\_ip<br>* eviction\_policy<br>* max\_pods<br>* mode<br>* node\_labels<br>* node\_taints<br>* orchestrator\_version<br>* os\_disk\_size\_gb<br>* os\_disk\_type<br>* os\_type<br>* priority<br>* spto\_max\_price<br>* tags<br>* max\_count<br>* min\_count<br>* node\_count<br>* max\_surge | `any` | `[]` | no |
| node\_taints | A list of Kubernetes taints which should be applied to nodes in the agent pool<br>(e.g key=value:NoSchedule). Changing this forces a new resource to be created. | `list(string)` | `null` | no |
| orchestrator\_version | Version of Kubernetes used for the Agents. If not specified, the latest<br>recommended version will be used at provisioning time (but won't auto-upgrade) | `string` | `null` | no |
| os\_disk\_size\_gb | The size of the OS Disk which should be used for each agent in the Node Pool.<br>Changing this forces a new resource to be created. | `number` | `null` | no |
| os\_disk\_type | The type of disk which should be used for the Operating System.<br>Possible values are Ephemeral and Managed.<br>Changing this forces a new resource to be created. | `string` | `"Managed"` | no |
| os\_type | The Operating System which should be used for this Node Pool. Changing this<br>forces a new resource to be created. Possible values are Linux and Windows. | `string` | `"Linux"` | no |
| priority | The Priority for Virtual Machines within the Virtual Machine Scale Set that<br>powers this Node Pool. Possible values are Regular and Spot.<br>Changing this forces a new resource to be created. | `string` | `"Regular"` | no |
| spot\_max\_price | The maximum price you're willing to pay in USD per Virtual Machine.<br>Valid values are -1 (the current on-demand price for a Virtual Machine) or a<br>positive value with up to five decimal places.<br>Changing this forces a new resource to be created. | `number` | `null` | no |
| tags | A mapping of tags which should be assigned to Resource. | `map(string)` | `{}` | no |
| vm\_size | The SKU which should be used for the Virtual Machines used in this Node Pool.<br>Changing this forces a new resource to be created. | `string` | `"Standard_D2s_v3"` | no |
| vnet\_subnet\_id | The ID of the Subnet where this Node Pool should exist.<br>At this time the vnet\_subnet\_id must be the same for all node pools in the cluster. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| regular\_node\_pools\_ids | Regular priority Node Pools IDs. |
| spot\_node\_pools\_ids | Spot priority Node Pools IDs. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
