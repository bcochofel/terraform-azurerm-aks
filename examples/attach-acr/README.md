# Basic AKS cluster

This example deploys a basic AKS cluster and attachs ACR for pulling images.

## Usage

```hcl:examples/attach-acr/main.tf
provider "azurerm" {
  features {}
}

module "rg" {
  source  = "bcochofel/resource-group/azurerm"
  version = "1.4.0"

  name     = "rg-aks-attach-acr-example"
  location = "North Europe"
}

module "acr" {
  source  = "bcochofel/acr/azurerm"
  version = "0.2.3"

  name                = "acrattachacrexample"
  resource_group_name = module.rg.name

  sku           = "Basic"
  admin_enabled = false

  depends_on = [module.rg]
}

module "aks" {
  source = "../.."

  name                = "aksattachacrexample"
  resource_group_name = module.rg.name
  dns_prefix          = "demolab"

  default_pool_name = "default"

  enable_attach_acr = true
  acr_id            = module.acr.id

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
| acr | bcochofel/acr/azurerm | 0.2.3 |
| aks | ../.. |  |
| rg | bcochofel/resource-group/azurerm | 1.4.0 |

## Resources

No resources.

## Inputs

No input.

## Outputs

| Name | Description |
|------|-------------|
| acr\_id | n/a |
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


