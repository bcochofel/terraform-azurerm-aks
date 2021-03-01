# AKS cluster with Network Policies

This example deploys a AKS cluster with Network Policies using calico.

## Usage

```hcl:examples/network-policy-calico/main.tf
provider "azurerm" {
  features {}
}

module "rg" {
  source  = "bcochofel/resource-group/azurerm"
  version = "1.4.0"

  name     = "rg-aks-calico-example"
  location = "North Europe"
}

module "aks" {
  source = "../.."

  name                = "akscalicoexample"
  resource_group_name = module.rg.name
  dns_prefix          = "demolab"

  default_pool_name = "default"

  network_plugin = "azure"
  network_policy = "calico"

  depends_on = [module.rg]
}

```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


## Requirements

No requirements.

## Providers

No provider.

## Modules

| Name | Source | Version |
|------|--------|---------|
| aks | ../.. |  |
| rg | bcochofel/resource-group/azurerm | 1.4.0 |

## Resources

No resources.

## Inputs

No input.

## Outputs

| Name | Description |
|------|-------------|
| fqdn | n/a |
| id | n/a |
| identity | n/a |
| kube\_admin\_config\_raw | n/a |
| kube\_config\_raw | n/a |
| kubelet\_identity | n/a |
| name | n/a |
| node\_resource\_group | n/a |
| private\_fqdn | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


