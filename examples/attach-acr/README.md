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

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_acr"></a> [acr](#module\_acr) | bcochofel/acr/azurerm | 0.2.3 |
| <a name="module_aks"></a> [aks](#module\_aks) | ../.. | n/a |
| <a name="module_rg"></a> [rg](#module\_rg) | bcochofel/resource-group/azurerm | 1.4.0 |

## Resources

No resources.

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_acr_id"></a> [acr\_id](#output\_acr\_id) | n/a |
| <a name="output_fqdn"></a> [fqdn](#output\_fqdn) | n/a |
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_identity"></a> [identity](#output\_identity) | n/a |
| <a name="output_kube_admin_config_raw"></a> [kube\_admin\_config\_raw](#output\_kube\_admin\_config\_raw) | n/a |
| <a name="output_kube_config_raw"></a> [kube\_config\_raw](#output\_kube\_config\_raw) | n/a |
| <a name="output_kubelet_identity"></a> [kubelet\_identity](#output\_kubelet\_identity) | n/a |
| <a name="output_name"></a> [name](#output\_name) | n/a |
| <a name="output_node_resource_group"></a> [node\_resource\_group](#output\_node\_resource\_group) | n/a |
| <a name="output_private_fqdn"></a> [private\_fqdn](#output\_private\_fqdn) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
