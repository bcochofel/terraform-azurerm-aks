# terraform-azurerm-aks

Terraform module for AzureRM Kubernetes Service.
This module validates the name according to Azure resource naming restrictions.

This module is inspired on the work from [this](https://github.com/Azure/terraform-azurerm-aks) repository.
Some examples where taken from [this](https://github.com/terraform-providers/terraform-provider-azurerm/tree/master/examples/kubernetes) repository.

## Usage

```hcl:examples/basic/main.tf
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
| terraform | >= 0.13.0 |
| azurerm | >= 2.49.0 |

## Providers

| Name | Version |
|------|---------|
| azurerm | >= 2.49.0 |
| random | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| node-pools | ./modules/node-pools |  |
| ssh-key | ./modules/ssh-key |  |

## Resources

| Name |
|------|
| [azurerm_kubernetes_cluster](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster) |
| [azurerm_log_analytics_solution](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_solution) |
| [azurerm_log_analytics_workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) |
| [azurerm_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) |
| [azurerm_role_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) |
| [random_string](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aci\_connector\_linux\_subnet\_name | The subnet name for the virtual nodes to run.<br>AKS will add a delegation to the subnet named here.<br>To prevent further runs from failing you should make sure that the subnet<br>you create for virtual nodes has a delegation, like so.<pre>hcl<br>resource "azurerm_subnet" "virtual" {<br><br>  #...<br><br>  delegation {<br>    name = "aciDelegation"<br>    service_delegation {<br>      name    = "Microsoft.ContainerInstance/containerGroups"<br>      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]<br>    }<br>  }<br>}</pre> | `string` | `null` | no |
| acr\_id | Attach ACR ID to allow ACR Pull from the SP/Managed Indentity. | `string` | `""` | no |
| admin\_username | The Admin Username for the Cluster.<br>Changing this forces a new resource to be created. | `string` | `"azureuser"` | no |
| agent\_tags | A mapping of tags to assign to the Node Pool. | `map(string)` | `{}` | no |
| agent\_type | The type of Node Pool which should be created.<br>Possible values are AvailabilitySet and VirtualMachineScaleSets. | `string` | `"VirtualMachineScaleSets"` | no |
| api\_server\_authorized\_ip\_ranges | The IP ranges to whitelist for incoming traffic to the masters. | `list(string)` | `null` | no |
| automatic\_channel\_upgrade | The upgrade channel for this Kubernetes Cluster.<br>Possible values are none, patch, rapid, and stable.<br>Cluster Auto-Upgrade will update the Kubernetes Cluster (and it's Node Pools)<br>to the latest GA version of Kubernetes automatically.<br>Please see [the Azure documentation for more information](https://docs.microsoft.com/en-us/azure/aks/upgrade-cluster#set-auto-upgrade-channel-preview). | `string` | `null` | no |
| availability\_zones | A list of Availability Zones across which the Node Pool should be spread.<br>Changing this forces a new resource to be created.<br>This requires that the type is set to VirtualMachineScaleSets and that<br>load\_balancer\_sku is set to Standard. | `list(string)` | `null` | no |
| default\_pool\_name | The name which should be used for the default Kubernetes Node Pool.<br>Changing this forces a new resource to be created. | `string` | n/a | yes |
| disk\_encryption\_set\_id | (Optional) The ID of the Disk Encryption Set which should be used for the Nodes and Volumes.<br>Please see [the documentation](https://docs.microsoft.com/en-us/azure/aks/azure-disk-customer-managed-keys)<br>and [disk\_encryption\_set](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/disk_encryption_set)<br>for more information. | `string` | `null` | no |
| dns\_prefix | DNS prefix specified when creating the managed cluster.<br>Changing this forces a new resource to be created. | `string` | n/a | yes |
| dns\_service\_ip | IP address within the Kubernetes service address range that will be used by<br>cluster service discovery (kube-dns).<br>Changing this forces a new resource to be created. | `string` | `null` | no |
| docker\_bridge\_cidr | IP address (in CIDR notation) used as the Docker bridge IP address on nodes.<br>Changing this forces a new resource to be created. | `string` | `null` | no |
| enable\_aci\_connector\_linux | Is the virtual node addon enabled? | `bool` | `false` | no |
| enable\_attach\_acr | Enable ACR Pull attach. Needs acr\_id to be defined. | `bool` | `false` | no |
| enable\_auto\_scaling | Should the Kubernetes Auto Scaler be enabled for this Node Pool?<br>This requires that the type is set to VirtualMachineScaleSets. | `bool` | `false` | no |
| enable\_azure\_active\_directory | Enable Azure Active Directory Integration? | `bool` | `false` | no |
| enable\_azure\_policy | Is the Azure Policy for Kubernetes Add On enabled? | `bool` | `false` | no |
| enable\_host\_encryption | Should the nodes in the Default Node Pool have host encryption enabled? | `bool` | `false` | no |
| enable\_http\_application\_routing | Is HTTP Application Routing Enabled? | `bool` | `false` | no |
| enable\_log\_analytics\_workspace | Enable the creation of azurerm\_log\_analytics\_workspace and<br>azurerm\_log\_analytics\_solution or not | `bool` | `false` | no |
| enable\_node\_public\_ip | Should nodes in this Node Pool have a Public IP Address? | `bool` | `false` | no |
| enable\_role\_based\_access\_control | Is Role Based Access Control Enabled?<br>Changing this forces a new resource to be created. | `bool` | `true` | no |
| enabled\_kube\_dashboard | Is the Kubernetes Dashboard enabled? | `bool` | `false` | no |
| kubernetes\_version | Version of Kubernetes specified when creating the AKS managed cluster.<br>If not specified, the latest recommended version will be used at provisioning time (but won't auto-upgrade). | `string` | `null` | no |
| load\_balancer\_sku | Specifies the SKU of the Load Balancer used for this Kubernetes Cluster.<br>Possible values are Basic and Standard. | `string` | `"Standard"` | no |
| log\_analytics\_workspace\_sku | The SKU (pricing level) of the Log Analytics workspace.<br>For new subscriptions the SKU should be set to PerGB2018 | `string` | `"PerGB2018"` | no |
| log\_retention\_in\_days | The retention period for the logs in days | `number` | `30` | no |
| max\_count | The maximum number of nodes which should exist in this Node Pool.<br>If specified this must be between 1 and 1000. | `number` | `null` | no |
| max\_pods | The maximum number of pods that can run on each agent.<br>Changing this forces a new resource to be created. | `number` | `null` | no |
| max\_surge | The maximum number or percentage of nodes which will be added to the Node Pool<br>size during an upgrade.<br>If a percentage is provided, the number of surge nodes is calculated from the<br>node\_count value on the current cluster. Node surge can allow a cluster to<br>have more nodes than max\_count during an upgrade. | `string` | `null` | no |
| min\_count | The minimum number of nodes which should exist in this Node Pool.<br>If specified this must be between 1 and 1000. | `number` | `null` | no |
| name | The name of the Managed Kubernetes Cluster to create.<br>Changing this forces a new resource to be created. | `string` | n/a | yes |
| network\_plugin | Network plugin to use for networking. Currently supported values are azure and kubenet.<br>Changing this forces a new resource to be created. | `string` | `"kubenet"` | no |
| network\_policy | Sets up network policy to be used with Azure CNI.<br>Currently supported values are calico and azure.<br>Changing this forces a new resource to be created. | `string` | `null` | no |
| node\_count | The initial number of nodes which should exist in this Node Pool. If specified<br>this must be between 1 and 1000 and between min\_count and max\_count. | `number` | `1` | no |
| node\_labels | A map of Kubernetes labels which should be applied to nodes in the Default Node Pool.<br>Changing this forces a new resource to be created. | `map(string)` | `{}` | no |
| node\_pools | Allows to create multiple Node Pools.<br><br>node\_pools can have more than one pool. The name attribute is used<br>to create key/value map, and priority is needed to filter, but all the other<br>elements are optional.<pre>hcl<br>node_pools = [<br>  {<br>    name = "user1"<br>    priority = "Regular"<br>  },<br>  {<br>    name = "spot1"<br>    priority = "Spot"<br>  }<br>]</pre>Valid fields are:<br><br>* vm\_size<br>* availability\_zones<br>* enable\_auto\_scaling<br>* enable\_host\_encryption<br>* enable\_node\_public\_ip<br>* eviction\_policy<br>* max\_pods<br>* mode<br>* node\_labels<br>* node\_taints<br>* orchestrator\_version<br>* os\_disk\_size\_gb<br>* os\_disk\_type<br>* os\_type<br>* priority<br>* spto\_max\_price<br>* tags<br>* max\_count<br>* min\_count<br>* node\_count<br>* max\_surge | `any` | `[]` | no |
| node\_resource\_group | The name of the Resource Group where the Kubernetes Nodes should exist.<br>Changing this forces a new resource to be created.<br>Azure requires that a new, non-existent Resource Group is used, as otherwise the<br>provisioning of the Kubernetes Service will fail. | `string` | `null` | no |
| only\_critical\_addons\_enabled | Enabling this option will taint default node pool with<br>CriticalAddonsOnly=true:NoSchedule taint.<br>Changing this forces a new resource to be created. | `bool` | `false` | no |
| orchestrator\_version | Version of Kubernetes used for the Agents. If not specified, the latest<br>recommended version will be used at provisioning time (but won't auto-upgrade) | `string` | `null` | no |
| os\_disk\_size\_gb | The size of the OS Disk which should be used for each agent in the Node Pool.<br>Changing this forces a new resource to be created. | `number` | `null` | no |
| os\_disk\_type | The type of disk which should be used for the Operating System.<br>Possible values are Ephemeral and Managed.<br>Changing this forces a new resource to be created. | `string` | `"Managed"` | no |
| outbound\_type | The outbound (egress) routing method which should be used for this Kubernetes<br>Cluster. Possible values are loadBalancer and userDefinedRouting. | `string` | `"loadBalancer"` | no |
| pod\_cidr | The CIDR to use for pod IP addresses. This field can only be set when<br>network\_plugin is set to kubenet.<br>Changing this forces a new resource to be created. | `string` | `null` | no |
| private\_cluster\_enabled | Should this Kubernetes Cluster have its API server only exposed on internal<br>IP addresses? This provides a Private IP Address for the Kubernetes API on the<br>Virtual Network where the Kubernetes Cluster is located.<br>Changing this forces a new resource to be created. | `bool` | `false` | no |
| private\_dns\_zone\_id | Either the ID of Private DNS Zone which should be delegated to this Cluster,<br>or System to have AKS manage this.<br>If you use BYO DNS Zone, AKS cluster should either use a User Assigned Identity<br>or a service principal (which is deprecated) with the Private DNS Zone Contributor<br>role and access to this Private DNS Zone. If UserAssigned identity is used - to<br>prevent improper resource order destruction - cluster should depend on the role assignment | `string` | `null` | no |
| public\_ssh\_key | The Public SSH Key used to access the cluster.<br>Changing this forces a new resource to be created. | `string` | `""` | no |
| rbac\_aad\_admin\_group\_object\_ids | Object ID of groups with admin access. | `list(string)` | `null` | no |
| rbac\_aad\_client\_app\_id | The Client ID of an Azure Active Directory Application. | `string` | `null` | no |
| rbac\_aad\_managed | Is the Azure Active Directory integration Managed, meaning that Azure will<br>create/manage the Service Principal used for integration. | `bool` | `false` | no |
| rbac\_aad\_server\_app\_id | The Server ID of an Azure Active Directory Application. | `string` | `null` | no |
| rbac\_aad\_server\_app\_secret | The Server Secret of an Azure Active Directory Application. | `string` | `null` | no |
| resource\_group\_name | The name of the resource group in which to create the AKS.<br>The Resource Group must already exist. | `string` | n/a | yes |
| service\_cidr | The Network Range used by the Kubernetes service.<br>Changing this forces a new resource to be created. | `string` | `null` | no |
| sku\_tier | The SKU Tier that should be used for this Kubernetes Cluster.<br>Possible values are Free and Paid (which includes the Uptime SLA). | `string` | `"Free"` | no |
| tags | A mapping of tags which should be assigned to Resources. | `map(string)` | `{}` | no |
| user\_assigned\_identity\_id | The ID of a user assigned identity. | `string` | `""` | no |
| vm\_size | The size of the Virtual Machine, such as Standard\_DS2\_v2. | `string` | `"Standard_D2s_v3"` | no |
| vnet\_subnet\_id | The ID of a Subnet where the Kubernetes Node Pool should exist.<br>Changing this forces a new resource to be created. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| client\_certificate | Client Certificate. |
| client\_key | Client Key |
| cluster\_ca\_certificate | Client CA Certificate. |
| fqdn | The FQDN of the Azure Kubernetes Managed Cluster. |
| host | Host |
| id | The Kubernetes Managed Cluster ID. |
| identity | A identity block |
| kube\_admin\_config | A kube\_admin\_config block. This is only available when Role Based Access Control<br>with Azure Active Directory is enabled. |
| kube\_admin\_config\_raw | Raw Kubernetes config for the admin account to be used by kubectl and other<br>compatible tools. This is only available when Role Based Access Control with<br>Azure Active Directory is enabled. |
| kube\_config | A kube\_config block. |
| kube\_config\_raw | Raw Kubernetes config to be used by kubectl and other compatible tools |
| kubelet\_identity | A kubelet\_identity block |
| name | The Kubernetes Managed Cluster name. |
| node\_resource\_group | The auto-generated Resource Group which contains the resources for this Managed<br>Kubernetes Cluster. |
| password | Password |
| private\_fqdn | The FQDN for the Kubernetes Cluster when private link has been enabled, which is<br>only resolvable inside the Virtual Network used by the Kubernetes Cluster. |
| username | Username |
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
