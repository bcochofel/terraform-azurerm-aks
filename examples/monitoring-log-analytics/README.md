# AKS cluster with Log Analytics

This example deploys a AKS cluster with Log Analytics Monitoring.

## Usage

```hcl:examples/monitoring-log-analytics/main.tf
provider "azurerm" {
  features {}
}

module "rg" {
  source  = "bcochofel/resource-group/azurerm"
  version = "1.4.0"

  name     = "rg-aks-loganalytics-example"
  location = "North Europe"
}

module "aks" {
  source = "../.."

  name                = "aksloganalyticsexample"
  resource_group_name = module.rg.name
  dns_prefix          = "demolab"

  default_pool_name = "default"

  enable_log_analytics_workspace = true

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


