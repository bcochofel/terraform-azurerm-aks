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
| [azurerm_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| agent\_tags | A mapping of tags to assign to the Node Pool. | `map(string)` | `{}` | no |
| agent\_type | The type of Node Pool which should be created.<br>Possible values are AvailabilitySet and VirtualMachineScaleSets. | `string` | `"VirtualMachineScaleSets"` | no |
| availability\_zones | A list of Availability Zones across which the Node Pool should be spread.<br>Changing this forces a new resource to be created.<br>This requires that the type is set to VirtualMachineScaleSets and that<br>load\_balancer\_sku is set to Standard. | `list(string)` | `null` | no |
| default\_pool\_name | The name which should be used for the default Kubernetes Node Pool.<br>Changing this forces a new resource to be created. | `string` | n/a | yes |
| dns\_prefix | DNS prefix specified when creating the managed cluster.<br>Changing this forces a new resource to be created. | `string` | n/a | yes |
| enable\_auto\_scaling | Should the Kubernetes Auto Scaler be enabled for this Node Pool?<br>This requires that the type is set to VirtualMachineScaleSets. | `bool` | `false` | no |
| enable\_host\_encryption | Should the nodes in the Default Node Pool have host encryption enabled? | `bool` | `false` | no |
| enable\_node\_public\_ip | Should nodes in this Node Pool have a Public IP Address? | `bool` | `false` | no |
| kubernetes\_version | Version of Kubernetes specified when creating the AKS managed cluster.<br>If not specified, the latest recommended version will be used at provisioning time (but won't auto-upgrade). | `string` | `null` | no |
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
| public\_ssh\_key | The Public SSH Key used to access the cluster.<br>Changing this forces a new resource to be created. | `string` | `""` | no |
| resource\_group\_name | The name of the resource group in which to create the AKS.<br>The Resource Group must already exist. | `string` | n/a | yes |
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
