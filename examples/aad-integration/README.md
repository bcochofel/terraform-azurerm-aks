# AKS cluster with Azure Active Directory Integration

This example deploys a AKS cluster with Azure Active Directory Integration..

**NOTE:** To run this example the `service principal` needs to have permissions
for Azure Active Directory. Please check references for more info.

## Usage

```hcl:examples/aad-integration/main.tf
provider "azurerm" {
  features {}
}

provider "azuread" {}

data "azuread_user" "aad" {
  mail_nickname = "bruno.cochofel_gmail.com#EXT#"
}

resource "azuread_group" "k8sadmins" {
  display_name = "Kubernetes Admins"
  members = [
    data.azuread_user.aad.object_id,
  ]
}

module "rg" {
  source  = "bcochofel/resource-group/azurerm"
  version = "1.4.0"

  name     = "rg-aks-aad-example"
  location = "North Europe"
}

module "aks" {
  source = "../.."

  name                = "aksaadexample"
  resource_group_name = module.rg.name
  dns_prefix          = "demolab"

  default_pool_name = "default"

  enable_azure_active_directory   = true
  rbac_aad_managed                = true
  rbac_aad_admin_group_object_ids = [azuread_group.k8sadmins.object_id]

  depends_on = [module.rg]
}

```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 2.53.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aks"></a> [aks](#module\_aks) | ../.. | n/a |
| <a name="module_rg"></a> [rg](#module\_rg) | bcochofel/resource-group/azurerm | 1.4.0 |

## Resources

| Name | Type |
|------|------|
| [azuread_group.k8sadmins](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group) | resource |
| [azuread_user.aad](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/user) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
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


# References

* [Terraform Azure AD Provider](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs)
* [Configuring a Service Principal for managing Azure Active Directory](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/guides/service_principal_configuration)
