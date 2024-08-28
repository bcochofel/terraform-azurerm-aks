# node-pools

Module to handle AKS Node Pools.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_kubernetes_cluster_node_pool.regular](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster_node_pool) | resource |
| [azurerm_kubernetes_cluster_node_pool.spot](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster_node_pool) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | A list of Availability Zones across which the Node Pool should be spread.<br>Changing this forces a new resource to be created.<br>This requires that the type is set to VirtualMachineScaleSets and that<br>load\_balancer\_sku is set to Standard. | `list(string)` | `null` | no |
| <a name="input_enable_auto_scaling"></a> [enable\_auto\_scaling](#input\_enable\_auto\_scaling) | Should the Kubernetes Auto Scaler be enabled for this Node Pool?<br>This requires that the type is set to VirtualMachineScaleSets. | `bool` | `false` | no |
| <a name="input_enable_host_encryption"></a> [enable\_host\_encryption](#input\_enable\_host\_encryption) | Should the nodes in the Default Node Pool have host encryption enabled? | `bool` | `false` | no |
| <a name="input_enable_node_public_ip"></a> [enable\_node\_public\_ip](#input\_enable\_node\_public\_ip) | Should nodes in this Node Pool have a Public IP Address? | `bool` | `false` | no |
| <a name="input_eviction_policy"></a> [eviction\_policy](#input\_eviction\_policy) | The Eviction Policy which should be used for Virtual Machines within the Virtual<br>Machine Scale Set powering this Node Pool.<br>Possible values are Deallocate and Delete.<br>Changing this forces a new resource to be created. | `string` | `"Delete"` | no |
| <a name="input_kubernetes_cluster_id"></a> [kubernetes\_cluster\_id](#input\_kubernetes\_cluster\_id) | The ID of the Kubernetes Cluster where this Node Pool should exist.<br>Changing this forces a new resource to be created.<br>The type of Default Node Pool for the Kubernetes Cluster must be<br>VirtualMachineScaleSets to attach multiple node pools. | `string` | n/a | yes |
| <a name="input_max_count"></a> [max\_count](#input\_max\_count) | The maximum number of nodes which should exist in this Node Pool.<br>If specified this must be between 1 and 1000. | `number` | `null` | no |
| <a name="input_max_pods"></a> [max\_pods](#input\_max\_pods) | The maximum number of pods that can run on each agent.<br>Changing this forces a new resource to be created. | `number` | `null` | no |
| <a name="input_max_surge"></a> [max\_surge](#input\_max\_surge) | The maximum number or percentage of nodes which will be added to the Node Pool<br>size during an upgrade.<br>If a percentage is provided, the number of surge nodes is calculated from the<br>node\_count value on the current cluster. Node surge can allow a cluster to<br>have more nodes than max\_count during an upgrade. | `string` | `null` | no |
| <a name="input_min_count"></a> [min\_count](#input\_min\_count) | The minimum number of nodes which should exist in this Node Pool.<br>If specified this must be between 1 and 1000. | `number` | `null` | no |
| <a name="input_mode"></a> [mode](#input\_mode) | Should this Node Pool be used for System or User resources?<br>Possible values are System and User. | `string` | `"User"` | no |
| <a name="input_node_count"></a> [node\_count](#input\_node\_count) | The initial number of nodes which should exist in this Node Pool. If specified<br>this must be between 1 and 1000 and between min\_count and max\_count. | `number` | `0` | no |
| <a name="input_node_labels"></a> [node\_labels](#input\_node\_labels) | A map of Kubernetes labels which should be applied to nodes in the Default Node Pool.<br>Changing this forces a new resource to be created. | `map(string)` | `{}` | no |
| <a name="input_node_pools"></a> [node\_pools](#input\_node\_pools) | Allows to create multiple Node Pools.<br><br>node\_pools can have more than one pool. The name attribute is used<br>to create key/value map, and priority is needed to filter, but all the other<br>elements are optional.<pre>hcl<br>node_pools = [<br>  {<br>    name = "user1"<br>    priority = "Regular"<br>  },<br>  {<br>    name = "spot1"<br>    priority = "Spot"<br>  }<br>]</pre>Valid fields are:<br><br>* vm\_size<br>* availability\_zones<br>* enable\_auto\_scaling<br>* enable\_host\_encryption<br>* enable\_node\_public\_ip<br>* eviction\_policy<br>* max\_pods<br>* mode<br>* node\_labels<br>* node\_taints<br>* orchestrator\_version<br>* os\_disk\_size\_gb<br>* os\_disk\_type<br>* os\_type<br>* priority<br>* spto\_max\_price<br>* tags<br>* max\_count<br>* min\_count<br>* node\_count<br>* max\_surge | `any` | `[]` | no |
| <a name="input_node_taints"></a> [node\_taints](#input\_node\_taints) | A list of Kubernetes taints which should be applied to nodes in the agent pool<br>(e.g key=value:NoSchedule). Changing this forces a new resource to be created. | `list(string)` | `null` | no |
| <a name="input_orchestrator_version"></a> [orchestrator\_version](#input\_orchestrator\_version) | Version of Kubernetes used for the Agents. If not specified, the latest<br>recommended version will be used at provisioning time (but won't auto-upgrade) | `string` | `null` | no |
| <a name="input_os_disk_size_gb"></a> [os\_disk\_size\_gb](#input\_os\_disk\_size\_gb) | The size of the OS Disk which should be used for each agent in the Node Pool.<br>Changing this forces a new resource to be created. | `number` | `null` | no |
| <a name="input_os_disk_type"></a> [os\_disk\_type](#input\_os\_disk\_type) | The type of disk which should be used for the Operating System.<br>Possible values are Ephemeral and Managed.<br>Changing this forces a new resource to be created. | `string` | `"Managed"` | no |
| <a name="input_os_type"></a> [os\_type](#input\_os\_type) | The Operating System which should be used for this Node Pool. Changing this<br>forces a new resource to be created. Possible values are Linux and Windows. | `string` | `"Linux"` | no |
| <a name="input_priority"></a> [priority](#input\_priority) | The Priority for Virtual Machines within the Virtual Machine Scale Set that<br>powers this Node Pool. Possible values are Regular and Spot.<br>Changing this forces a new resource to be created. | `string` | `"Regular"` | no |
| <a name="input_spot_max_price"></a> [spot\_max\_price](#input\_spot\_max\_price) | The maximum price you're willing to pay in USD per Virtual Machine.<br>Valid values are -1 (the current on-demand price for a Virtual Machine) or a<br>positive value with up to five decimal places.<br>Changing this forces a new resource to be created. | `number` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags which should be assigned to Resource. | `map(string)` | `{}` | no |
| <a name="input_vm_size"></a> [vm\_size](#input\_vm\_size) | The SKU which should be used for the Virtual Machines used in this Node Pool.<br>Changing this forces a new resource to be created. | `string` | `"Standard_D2s_v3"` | no |
| <a name="input_vnet_subnet_id"></a> [vnet\_subnet\_id](#input\_vnet\_subnet\_id) | The ID of the Subnet where this Node Pool should exist.<br>At this time the vnet\_subnet\_id must be the same for all node pools in the cluster. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_regular_node_pools_ids"></a> [regular\_node\_pools\_ids](#output\_regular\_node\_pools\_ids) | Regular priority Node Pools IDs. |
| <a name="output_spot_node_pools_ids"></a> [spot\_node\_pools\_ids](#output\_spot\_node\_pools\_ids) | Spot priority Node Pools IDs. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
