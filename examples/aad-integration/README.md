# AKS cluster with Azure Active Directory Integration

This example deploys a AKS cluster with Azure Active Directory Integration..

**NOTE:** To run this example the `service principal` needs to have permissions
for Azure Active Directory. Please check references for more info.

## Usage

```hcl:examples/aad-integration/main.tf
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| azuread | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| aks | ../.. |  |
| rg | bcochofel/resource-group/azurerm | 1.4.0 |

## Resources

| Name |
|------|
| [azuread_group](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group) |
| [azuread_user](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/user) |

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

# References

* [Terraform Azure AD Provider](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs)
* [Configuring a Service Principal for managing Azure Active Directory](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/guides/service_principal_configuration)
