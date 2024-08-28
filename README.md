# terraform-azurerm-aks

Terraform module for AzureRM Kubernetes Service.
This module validates the name according to Azure resource naming restrictions.

This module is inspired on the work from [this](https://github.com/Azure/terraform-azurerm-aks) repository.
Some examples where taken from [this](https://github.com/terraform-providers/terraform-provider-azurerm/tree/master/examples/kubernetes) repository.

## Usage

```hcl
provider "azurerm" {
  features {}
}

module "rg" {
  source  = "bcochofel/resource-group/azurerm"
  version = "1.4.0"

  name     = "rg-aks-basic-example"
  location = "North Europe"
}

module "aks" {
  source = "../.."

  name                = "aksbasicexample"
  resource_group_name = module.rg.name
  dns_prefix          = "demolab"

  default_pool_name = "default"

  depends_on = [module.rg]
}

```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 2.49.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 2.49.0 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_node-pools"></a> [node-pools](#module\_node-pools) | ./modules/node-pools | n/a |
| <a name="module_ssh-key"></a> [ssh-key](#module\_ssh-key) | ./modules/ssh-key | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_kubernetes_cluster.aks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster) | resource |
| [azurerm_log_analytics_solution.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_solution) | resource |
| [azurerm_log_analytics_workspace.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |
| [azurerm_role_assignment.aks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.attach_acr](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [random_string.main](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aci_connector_linux_subnet_name"></a> [aci\_connector\_linux\_subnet\_name](#input\_aci\_connector\_linux\_subnet\_name) | The subnet name for the virtual nodes to run.<br>AKS will add a delegation to the subnet named here.<br>To prevent further runs from failing you should make sure that the subnet<br>you create for virtual nodes has a delegation, like so.<pre>hcl<br>resource "azurerm_subnet" "virtual" {<br><br>  #...<br><br>  delegation {<br>    name = "aciDelegation"<br>    service_delegation {<br>      name    = "Microsoft.ContainerInstance/containerGroups"<br>      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]<br>    }<br>  }<br>}</pre> | `string` | `null` | no |
| <a name="input_acr_id"></a> [acr\_id](#input\_acr\_id) | Attach ACR ID to allow ACR Pull from the SP/Managed Indentity. | `string` | `""` | no |
| <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username) | The Admin Username for the Cluster.<br>Changing this forces a new resource to be created. | `string` | `"azureuser"` | no |
| <a name="input_agent_tags"></a> [agent\_tags](#input\_agent\_tags) | A mapping of tags to assign to the Node Pool. | `map(string)` | `{}` | no |
| <a name="input_agent_type"></a> [agent\_type](#input\_agent\_type) | The type of Node Pool which should be created.<br>Possible values are AvailabilitySet and VirtualMachineScaleSets. | `string` | `"VirtualMachineScaleSets"` | no |
| <a name="input_api_server_authorized_ip_ranges"></a> [api\_server\_authorized\_ip\_ranges](#input\_api\_server\_authorized\_ip\_ranges) | The IP ranges to whitelist for incoming traffic to the masters. | `list(string)` | `null` | no |
| <a name="input_automatic_channel_upgrade"></a> [automatic\_channel\_upgrade](#input\_automatic\_channel\_upgrade) | The upgrade channel for this Kubernetes Cluster.<br>Possible values are none, patch, rapid, and stable.<br>Cluster Auto-Upgrade will update the Kubernetes Cluster (and it's Node Pools)<br>to the latest GA version of Kubernetes automatically.<br>Please see [the Azure documentation for more information](https://docs.microsoft.com/en-us/azure/aks/upgrade-cluster#set-auto-upgrade-channel-preview). | `string` | `null` | no |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | A list of Availability Zones across which the Node Pool should be spread.<br>Changing this forces a new resource to be created.<br>This requires that the type is set to VirtualMachineScaleSets and that<br>load\_balancer\_sku is set to Standard. | `list(string)` | `null` | no |
| <a name="input_default_pool_name"></a> [default\_pool\_name](#input\_default\_pool\_name) | The name which should be used for the default Kubernetes Node Pool.<br>Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_disk_encryption_set_id"></a> [disk\_encryption\_set\_id](#input\_disk\_encryption\_set\_id) | (Optional) The ID of the Disk Encryption Set which should be used for the Nodes and Volumes.<br>Please see [the documentation](https://docs.microsoft.com/en-us/azure/aks/azure-disk-customer-managed-keys)<br>and [disk\_encryption\_set](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/disk_encryption_set)<br>for more information. | `string` | `null` | no |
| <a name="input_dns_prefix"></a> [dns\_prefix](#input\_dns\_prefix) | DNS prefix specified when creating the managed cluster.<br>Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_dns_service_ip"></a> [dns\_service\_ip](#input\_dns\_service\_ip) | IP address within the Kubernetes service address range that will be used by<br>cluster service discovery (kube-dns).<br>Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_docker_bridge_cidr"></a> [docker\_bridge\_cidr](#input\_docker\_bridge\_cidr) | IP address (in CIDR notation) used as the Docker bridge IP address on nodes.<br>Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_enable_aci_connector_linux"></a> [enable\_aci\_connector\_linux](#input\_enable\_aci\_connector\_linux) | Is the virtual node addon enabled? | `bool` | `false` | no |
| <a name="input_enable_attach_acr"></a> [enable\_attach\_acr](#input\_enable\_attach\_acr) | Enable ACR Pull attach. Needs acr\_id to be defined. | `bool` | `false` | no |
| <a name="input_enable_auto_scaling"></a> [enable\_auto\_scaling](#input\_enable\_auto\_scaling) | Should the Kubernetes Auto Scaler be enabled for this Node Pool?<br>This requires that the type is set to VirtualMachineScaleSets. | `bool` | `false` | no |
| <a name="input_enable_azure_active_directory"></a> [enable\_azure\_active\_directory](#input\_enable\_azure\_active\_directory) | Enable Azure Active Directory Integration? | `bool` | `false` | no |
| <a name="input_enable_azure_policy"></a> [enable\_azure\_policy](#input\_enable\_azure\_policy) | Is the Azure Policy for Kubernetes Add On enabled? | `bool` | `false` | no |
| <a name="input_enable_host_encryption"></a> [enable\_host\_encryption](#input\_enable\_host\_encryption) | Should the nodes in the Default Node Pool have host encryption enabled? | `bool` | `false` | no |
| <a name="input_enable_http_application_routing"></a> [enable\_http\_application\_routing](#input\_enable\_http\_application\_routing) | Is HTTP Application Routing Enabled? | `bool` | `false` | no |
| <a name="input_enable_log_analytics_workspace"></a> [enable\_log\_analytics\_workspace](#input\_enable\_log\_analytics\_workspace) | Enable the creation of azurerm\_log\_analytics\_workspace and<br>azurerm\_log\_analytics\_solution or not | `bool` | `false` | no |
| <a name="input_enable_node_public_ip"></a> [enable\_node\_public\_ip](#input\_enable\_node\_public\_ip) | Should nodes in this Node Pool have a Public IP Address? | `bool` | `false` | no |
| <a name="input_enable_role_based_access_control"></a> [enable\_role\_based\_access\_control](#input\_enable\_role\_based\_access\_control) | Is Role Based Access Control Enabled?<br>Changing this forces a new resource to be created. | `bool` | `true` | no |
| <a name="input_enabled_kube_dashboard"></a> [enabled\_kube\_dashboard](#input\_enabled\_kube\_dashboard) | Is the Kubernetes Dashboard enabled? | `bool` | `false` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Version of Kubernetes specified when creating the AKS managed cluster.<br>If not specified, the latest recommended version will be used at provisioning time (but won't auto-upgrade). | `string` | `null` | no |
| <a name="input_load_balancer_sku"></a> [load\_balancer\_sku](#input\_load\_balancer\_sku) | Specifies the SKU of the Load Balancer used for this Kubernetes Cluster.<br>Possible values are Basic and Standard. | `string` | `"Standard"` | no |
| <a name="input_log_analytics_workspace_sku"></a> [log\_analytics\_workspace\_sku](#input\_log\_analytics\_workspace\_sku) | The SKU (pricing level) of the Log Analytics workspace.<br>For new subscriptions the SKU should be set to PerGB2018 | `string` | `"PerGB2018"` | no |
| <a name="input_log_retention_in_days"></a> [log\_retention\_in\_days](#input\_log\_retention\_in\_days) | The retention period for the logs in days | `number` | `30` | no |
| <a name="input_max_count"></a> [max\_count](#input\_max\_count) | The maximum number of nodes which should exist in this Node Pool.<br>If specified this must be between 1 and 1000. | `number` | `null` | no |
| <a name="input_max_pods"></a> [max\_pods](#input\_max\_pods) | The maximum number of pods that can run on each agent.<br>Changing this forces a new resource to be created. | `number` | `null` | no |
| <a name="input_max_surge"></a> [max\_surge](#input\_max\_surge) | The maximum number or percentage of nodes which will be added to the Node Pool<br>size during an upgrade.<br>If a percentage is provided, the number of surge nodes is calculated from the<br>node\_count value on the current cluster. Node surge can allow a cluster to<br>have more nodes than max\_count during an upgrade. | `string` | `null` | no |
| <a name="input_min_count"></a> [min\_count](#input\_min\_count) | The minimum number of nodes which should exist in this Node Pool.<br>If specified this must be between 1 and 1000. | `number` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the Managed Kubernetes Cluster to create.<br>Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_network_plugin"></a> [network\_plugin](#input\_network\_plugin) | Network plugin to use for networking. Currently supported values are azure and kubenet.<br>Changing this forces a new resource to be created. | `string` | `"kubenet"` | no |
| <a name="input_network_policy"></a> [network\_policy](#input\_network\_policy) | Sets up network policy to be used with Azure CNI.<br>Currently supported values are calico and azure.<br>Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_node_count"></a> [node\_count](#input\_node\_count) | The initial number of nodes which should exist in this Node Pool. If specified<br>this must be between 1 and 1000 and between min\_count and max\_count. | `number` | `1` | no |
| <a name="input_node_labels"></a> [node\_labels](#input\_node\_labels) | A map of Kubernetes labels which should be applied to nodes in the Default Node Pool.<br>Changing this forces a new resource to be created. | `map(string)` | `{}` | no |
| <a name="input_node_pools"></a> [node\_pools](#input\_node\_pools) | Allows to create multiple Node Pools.<br><br>node\_pools can have more than one pool. The name attribute is used<br>to create key/value map, and priority is needed to filter, but all the other<br>elements are optional.<pre>hcl<br>node_pools = [<br>  {<br>    name = "user1"<br>    priority = "Regular"<br>  },<br>  {<br>    name = "spot1"<br>    priority = "Spot"<br>  }<br>]</pre>Valid fields are:<br><br>* vm\_size<br>* availability\_zones<br>* enable\_auto\_scaling<br>* enable\_host\_encryption<br>* enable\_node\_public\_ip<br>* eviction\_policy<br>* max\_pods<br>* mode<br>* node\_labels<br>* node\_taints<br>* orchestrator\_version<br>* os\_disk\_size\_gb<br>* os\_disk\_type<br>* os\_type<br>* priority<br>* spto\_max\_price<br>* tags<br>* max\_count<br>* min\_count<br>* node\_count<br>* max\_surge | `any` | `[]` | no |
| <a name="input_node_resource_group"></a> [node\_resource\_group](#input\_node\_resource\_group) | The name of the Resource Group where the Kubernetes Nodes should exist.<br>Changing this forces a new resource to be created.<br>Azure requires that a new, non-existent Resource Group is used, as otherwise the<br>provisioning of the Kubernetes Service will fail. | `string` | `null` | no |
| <a name="input_only_critical_addons_enabled"></a> [only\_critical\_addons\_enabled](#input\_only\_critical\_addons\_enabled) | Enabling this option will taint default node pool with<br>CriticalAddonsOnly=true:NoSchedule taint.<br>Changing this forces a new resource to be created. | `bool` | `false` | no |
| <a name="input_orchestrator_version"></a> [orchestrator\_version](#input\_orchestrator\_version) | Version of Kubernetes used for the Agents. If not specified, the latest<br>recommended version will be used at provisioning time (but won't auto-upgrade) | `string` | `null` | no |
| <a name="input_os_disk_size_gb"></a> [os\_disk\_size\_gb](#input\_os\_disk\_size\_gb) | The size of the OS Disk which should be used for each agent in the Node Pool.<br>Changing this forces a new resource to be created. | `number` | `null` | no |
| <a name="input_os_disk_type"></a> [os\_disk\_type](#input\_os\_disk\_type) | The type of disk which should be used for the Operating System.<br>Possible values are Ephemeral and Managed.<br>Changing this forces a new resource to be created. | `string` | `"Managed"` | no |
| <a name="input_outbound_type"></a> [outbound\_type](#input\_outbound\_type) | The outbound (egress) routing method which should be used for this Kubernetes<br>Cluster. Possible values are loadBalancer and userDefinedRouting. | `string` | `"loadBalancer"` | no |
| <a name="input_pod_cidr"></a> [pod\_cidr](#input\_pod\_cidr) | The CIDR to use for pod IP addresses. This field can only be set when<br>network\_plugin is set to kubenet.<br>Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_private_cluster_enabled"></a> [private\_cluster\_enabled](#input\_private\_cluster\_enabled) | Should this Kubernetes Cluster have its API server only exposed on internal<br>IP addresses? This provides a Private IP Address for the Kubernetes API on the<br>Virtual Network where the Kubernetes Cluster is located.<br>Changing this forces a new resource to be created. | `bool` | `false` | no |
| <a name="input_private_dns_zone_id"></a> [private\_dns\_zone\_id](#input\_private\_dns\_zone\_id) | Either the ID of Private DNS Zone which should be delegated to this Cluster,<br>or System to have AKS manage this.<br>If you use BYO DNS Zone, AKS cluster should either use a User Assigned Identity<br>or a service principal (which is deprecated) with the Private DNS Zone Contributor<br>role and access to this Private DNS Zone. If UserAssigned identity is used - to<br>prevent improper resource order destruction - cluster should depend on the role assignment | `string` | `null` | no |
| <a name="input_public_ssh_key"></a> [public\_ssh\_key](#input\_public\_ssh\_key) | The Public SSH Key used to access the cluster.<br>Changing this forces a new resource to be created. | `string` | `""` | no |
| <a name="input_rbac_aad_admin_group_object_ids"></a> [rbac\_aad\_admin\_group\_object\_ids](#input\_rbac\_aad\_admin\_group\_object\_ids) | Object ID of groups with admin access. | `list(string)` | `null` | no |
| <a name="input_rbac_aad_client_app_id"></a> [rbac\_aad\_client\_app\_id](#input\_rbac\_aad\_client\_app\_id) | The Client ID of an Azure Active Directory Application. | `string` | `null` | no |
| <a name="input_rbac_aad_managed"></a> [rbac\_aad\_managed](#input\_rbac\_aad\_managed) | Is the Azure Active Directory integration Managed, meaning that Azure will<br>create/manage the Service Principal used for integration. | `bool` | `false` | no |
| <a name="input_rbac_aad_server_app_id"></a> [rbac\_aad\_server\_app\_id](#input\_rbac\_aad\_server\_app\_id) | The Server ID of an Azure Active Directory Application. | `string` | `null` | no |
| <a name="input_rbac_aad_server_app_secret"></a> [rbac\_aad\_server\_app\_secret](#input\_rbac\_aad\_server\_app\_secret) | The Server Secret of an Azure Active Directory Application. | `string` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which to create the AKS.<br>The Resource Group must already exist. | `string` | n/a | yes |
| <a name="input_service_cidr"></a> [service\_cidr](#input\_service\_cidr) | The Network Range used by the Kubernetes service.<br>Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_sku_tier"></a> [sku\_tier](#input\_sku\_tier) | The SKU Tier that should be used for this Kubernetes Cluster.<br>Possible values are Free and Paid (which includes the Uptime SLA). | `string` | `"Free"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags which should be assigned to Resources. | `map(string)` | `{}` | no |
| <a name="input_user_assigned_identity_id"></a> [user\_assigned\_identity\_id](#input\_user\_assigned\_identity\_id) | The ID of a user assigned identity. | `string` | `""` | no |
| <a name="input_vm_size"></a> [vm\_size](#input\_vm\_size) | The size of the Virtual Machine, such as Standard\_DS2\_v2. | `string` | `"Standard_D2s_v3"` | no |
| <a name="input_vnet_subnet_id"></a> [vnet\_subnet\_id](#input\_vnet\_subnet\_id) | The ID of a Subnet where the Kubernetes Node Pool should exist.<br>Changing this forces a new resource to be created. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_client_certificate"></a> [client\_certificate](#output\_client\_certificate) | Client Certificate. |
| <a name="output_client_key"></a> [client\_key](#output\_client\_key) | Client Key |
| <a name="output_cluster_ca_certificate"></a> [cluster\_ca\_certificate](#output\_cluster\_ca\_certificate) | Client CA Certificate. |
| <a name="output_fqdn"></a> [fqdn](#output\_fqdn) | The FQDN of the Azure Kubernetes Managed Cluster. |
| <a name="output_host"></a> [host](#output\_host) | Host |
| <a name="output_id"></a> [id](#output\_id) | The Kubernetes Managed Cluster ID. |
| <a name="output_identity"></a> [identity](#output\_identity) | A identity block |
| <a name="output_kube_admin_config"></a> [kube\_admin\_config](#output\_kube\_admin\_config) | A kube\_admin\_config block. This is only available when Role Based Access Control<br>with Azure Active Directory is enabled. |
| <a name="output_kube_admin_config_raw"></a> [kube\_admin\_config\_raw](#output\_kube\_admin\_config\_raw) | Raw Kubernetes config for the admin account to be used by kubectl and other<br>compatible tools. This is only available when Role Based Access Control with<br>Azure Active Directory is enabled. |
| <a name="output_kube_config"></a> [kube\_config](#output\_kube\_config) | A kube\_config block. |
| <a name="output_kube_config_raw"></a> [kube\_config\_raw](#output\_kube\_config\_raw) | Raw Kubernetes config to be used by kubectl and other compatible tools |
| <a name="output_kubelet_identity"></a> [kubelet\_identity](#output\_kubelet\_identity) | A kubelet\_identity block |
| <a name="output_name"></a> [name](#output\_name) | The Kubernetes Managed Cluster name. |
| <a name="output_node_resource_group"></a> [node\_resource\_group](#output\_node\_resource\_group) | The auto-generated Resource Group which contains the resources for this Managed<br>Kubernetes Cluster. |
| <a name="output_password"></a> [password](#output\_password) | Password |
| <a name="output_private_fqdn"></a> [private\_fqdn](#output\_private\_fqdn) | The FQDN for the Kubernetes Cluster when private link has been enabled, which is<br>only resolvable inside the Virtual Network used by the Kubernetes Cluster. |
| <a name="output_username"></a> [username](#output\_username) | Username |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


## Run tests

```bash
cd test/
go test -v
```

## pre-commit hooks

This repository uses [pre-commit](https://pre-commit.com/).

To install execute:

```bash
pre-commit install --install-hooks -t commit-msg
```

To run the hooks you need to install:

* [terraform](https://github.com/hashicorp/terraform)
* [terraform-docs](https://github.com/terraform-docs/terraform-docs)
* [TFLint](https://github.com/terraform-linters/tflint)
* [TFSec](https://github.com/tfsec/tfsec)
* [checkov](https://github.com/bridgecrewio/checkov)

## References

* [Azure resource naming restrictions](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/resource-name-rules)
* [AKS Overview](https://docs.microsoft.com/en-us/azure/aks/intro-kubernetes)
