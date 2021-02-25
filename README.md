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
| terraform | >= 0.12.20 |
| azurerm | >= 2.48.0 |

## Providers

| Name | Version |
|------|---------|
| azurerm | >= 2.48.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| ssh-key | ./modules/ssh-key |  |

## Resources

| Name |
|------|
| [azurerm_kubernetes_cluster](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster) |
| [azurerm_log_analytics_solution](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_solution) |
| [azurerm_log_analytics_workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) |
| [azurerm_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aci\_connector\_linux\_subnet\_name | The subnet name for the virtual nodes to run.<br>AKS will add a delegation to the subnet named here.<br>To prevent further runs from failing you should make sure that the subnet<br>you create for virtual nodes has a delegation, like so.<pre>hcl<br>resource "azurerm_subnet" "virtual" {<br><br>  #...<br><br>  delegation {<br>    name = "aciDelegation"<br>    service_delegation {<br>      name    = "Microsoft.ContainerInstance/containerGroups"<br>      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]<br>    }<br>  }<br>}</pre> | `string` | `null` | no |
| admin\_username | The Admin Username for the Cluster.<br>Changing this forces a new resource to be created. | `string` | `"azureuser"` | no |
| agent\_tags | A mapping of tags to assign to the Node Pool. | `map(string)` | `{}` | no |
| agent\_type | The type of Node Pool which should be created.<br>Possible values are AvailabilitySet and VirtualMachineScaleSets. | `string` | `"VirtualMachineScaleSets"` | no |
| api\_server\_authorized\_ip\_ranges | The IP ranges to whitelist for incoming traffic to the masters. | `list(string)` | `null` | no |
| automatic\_channel\_upgrade | The upgrade channel for this Kubernetes Cluster.<br>Possible values are none, patch, rapid, and stable.<br>Cluster Auto-Upgrade will update the Kubernetes Cluster (and it's Node Pools)<br>to the latest GA version of Kubernetes automatically.<br>Please see [the Azure documentation for more information](https://docs.microsoft.com/en-us/azure/aks/upgrade-cluster#set-auto-upgrade-channel-preview). | `string` | `"none"` | no |
| availability\_zones | A list of Availability Zones across which the Node Pool should be spread.<br>Changing this forces a new resource to be created.<br>This requires that the type is set to VirtualMachineScaleSets and that<br>load\_balancer\_sku is set to Standard. | `list(string)` | `null` | no |
| client\_id | (Optional) The Client ID (appId) for the Service Principal used for the AKS deployment | `string` | `""` | no |
| client\_secret | (Optional) The Client Secret (password) for the Service Principal used for the AKS deployment | `string` | `""` | no |
| default\_pool\_name | The name which should be used for the default Kubernetes Node Pool.<br>Changing this forces a new resource to be created. | `string` | n/a | yes |
| disk\_encryption\_set\_id | (Optional) The ID of the Disk Encryption Set which should be used for the Nodes and Volumes.<br>Please see [the documentation](https://docs.microsoft.com/en-us/azure/aks/azure-disk-customer-managed-keys)<br>and [disk\_encryption\_set](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/disk_encryption_set)<br>for more information. | `string` | `null` | no |
| dns\_prefix | DNS prefix specified when creating the managed cluster.<br>Changing this forces a new resource to be created. | `string` | n/a | yes |
| enable\_aci\_connector\_linux | Is the virtual node addon enabled? | `bool` | `false` | no |
| enable\_auto\_scaling | Should the Kubernetes Auto Scaler be enabled for this Node Pool?<br>This requires that the type is set to VirtualMachineScaleSets. | `bool` | `false` | no |
| enable\_azure\_policy | Is the Azure Policy for Kubernetes Add On enabled? | `bool` | `false` | no |
| enable\_host\_encryption | Should the nodes in the Default Node Pool have host encryption enabled? | `bool` | `false` | no |
| enable\_http\_application\_routing | Is HTTP Application Routing Enabled? | `bool` | `false` | no |
| enable\_log\_analytics\_workspace | Enable the creation of azurerm\_log\_analytics\_workspace and<br>azurerm\_log\_analytics\_solution or not | `bool` | `true` | no |
| enable\_node\_public\_ip | Should nodes in this Node Pool have a Public IP Address? | `bool` | `false` | no |
| enable\_role\_based\_access\_control | Is Role Based Access Control Enabled?<br>Changing this forces a new resource to be created. | `bool` | `true` | no |
| enabled\_kube\_dashboard | Is the Kubernetes Dashboard enabled? | `bool` | `false` | no |
| kubernetes\_version | Version of Kubernetes specified when creating the AKS managed cluster.<br>If not specified, the latest recommended version will be used at provisioning time (but won't auto-upgrade). | `string` | `null` | no |
| log\_analytics\_workspace\_sku | The SKU (pricing level) of the Log Analytics workspace.<br>For new subscriptions the SKU should be set to PerGB2018 | `string` | `"PerGB2018"` | no |
| log\_retention\_in\_days | The retention period for the logs in days | `number` | `30` | no |
| max\_count | The maximum number of nodes which should exist in this Node Pool.<br>If specified this must be between 1 and 1000. | `number` | `null` | no |
| max\_pods | The maximum number of pods that can run on each agent.<br>Changing this forces a new resource to be created. | `number` | `null` | no |
| max\_surge | The maximum number or percentage of nodes which will be added to the Node Pool<br>size during an upgrade.<br>If a percentage is provided, the number of surge nodes is calculated from the<br>node\_count value on the current cluster. Node surge can allow a cluster to<br>have more nodes than max\_count during an upgrade. | `string` | `null` | no |
| min\_count | The minimum number of nodes which should exist in this Node Pool.<br>If specified this must be between 1 and 1000. | `number` | `null` | no |
| name | The name of the Managed Kubernetes Cluster to create.<br>Changing this forces a new resource to be created. | `string` | n/a | yes |
| node\_count | The initial number of nodes which should exist in this Node Pool. If specified<br>this must be between 1 and 1000 and between min\_count and max\_count. | `number` | `null` | no |
| node\_labels | A map of Kubernetes labels which should be applied to nodes in the Default Node Pool.<br>Changing this forces a new resource to be created. | `map(string)` | `{}` | no |
| only\_critical\_addons\_enabled | Enabling this option will taint default node pool with<br>CriticalAddonsOnly=true:NoSchedule taint.<br>Changing this forces a new resource to be created. | `bool` | `false` | no |
| orchestrator\_version | Version of Kubernetes used for the Agents. If not specified, the latest<br>recommended version will be used at provisioning time (but won't auto-upgrade) | `string` | `null` | no |
| os\_disk\_size\_gb | The size of the OS Disk which should be used for each agent in the Node Pool.<br>Changing this forces a new resource to be created. | `number` | `null` | no |
| os\_disk\_type | The type of disk which should be used for the Operating System.<br>Possible values are Ephemeral and Managed.<br>Changing this forces a new resource to be created. | `string` | `"Managed"` | no |
| private\_cluster\_enabled | Should this Kubernetes Cluster have its API server only exposed on internal<br>IP addresses? This provides a Private IP Address for the Kubernetes API on the<br>Virtual Network where the Kubernetes Cluster is located.<br>Changing this forces a new resource to be created. | `bool` | `false` | no |
| public\_ssh\_key | The Public SSH Key used to access the cluster.<br>Changing this forces a new resource to be created. | `string` | `""` | no |
| resource\_group\_name | The name of the resource group in which to create the AKS.<br>The Resource Group must already exist. | `string` | n/a | yes |
| tags | A mapping of tags which should be assigned to Resources. | `map(string)` | `{}` | no |
| user\_assigned\_identity\_id | The ID of a user assigned identity. | `string` | `""` | no |
| vm\_size | The size of the Virtual Machine, such as Standard\_DS2\_v2. | `string` | `"Standard_D2s_v3"` | no |
| vnet\_subnet\_id | The ID of a Subnet where the Kubernetes Node Pool should exist.<br>Changing this forces a new resource to be created. | `string` | `null` | no |

## Outputs

No output.
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
* [Terraform azurerm_kubernetes_cluster](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster)
