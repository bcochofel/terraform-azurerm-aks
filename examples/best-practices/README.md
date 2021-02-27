# AKS cluster with some best practices

This example deploys a AKS cluster with some best practices.

## Usage

```hcl:examples/best-practices/main.tf
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
| subnet | bcochofel/subnet/azurerm | 1.3.1 |
| vnet | bcochofel/virtual-network/azurerm | 1.2.1 |

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

## References

* [Azure AKS best practices overview](https://docs.microsoft.com/en-us/azure/aks/best-practices)
