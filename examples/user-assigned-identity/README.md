# AKS cluster user assigned managed identity

This example deploys a AKS cluster with Managed Identity (user assigned).

## Usage

```hcl:examples/user-assigned-identity/main.tf
provider "azurerm" {
  features {}
}

data "azurerm_subscription" "sub" {}

module "rg" {
  source  = "bcochofel/resource-group/azurerm"
  version = "1.4.0"

  name     = "rg-aks-user-assigned-identity-example"
  location = "North Europe"
}

resource "azurerm_user_assigned_identity" "aks_identity" {
  resource_group_name = module.rg.name
  location            = module.rg.location

  name = "aks-identity"
}

module "aks" {
  source = "../.."

  name                = "aksuserassignedexample"
  resource_group_name = module.rg.name
  dns_prefix          = "demolab"

  default_pool_name = "default"

  user_assigned_identity_id = azurerm_user_assigned_identity.aks_identity.id

  node_resource_group = "aks-node-rg"

  depends_on = [module.rg]
}

```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| azurerm | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| aks | ../.. |  |
| rg | bcochofel/resource-group/azurerm | 1.4.0 |

## Resources

| Name |
|------|
| [azurerm_subscription](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) |
| [azurerm_user_assigned_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) |

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


