# AKS cluster with some best practices

This example deploys a AKS cluster with some best practices like:

* Azure AD integration
* Private cluster with private DNS zone
* User Identity (with role assignment to RG and Private DNS)
* Node pools with auto-scale enabled and Availability Zones
* Azure Monitoring
* Azure CNI with calico
* Default Node pool with taints for critical add-ons only

To be able to deploy to the default node pool use the following tolerations:

```yaml
tolerations:
  - key: "CriticalAddonsOnly"
    operator: "Equal"
    value: "true"
    effect: NoSchedule
```

## Usage

```hcl:examples/best-practices/main.tf
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

  name     = "rg-${var.identifier}-example"
  location = var.location
}

resource "azurerm_user_assigned_identity" "main" {
  resource_group_name = module.rg.name
  location            = module.rg.location

  name = "identity-${var.identifier}-example"
}

module "vnet" {
  source  = "bcochofel/virtual-network/azurerm"
  version = "1.2.1"

  resource_group_name = module.rg.name
  name                = "vnet-${var.identifier}-example"
  address_space       = ["10.5.0.0/16"]

  depends_on = [module.rg]
}

module "subnet" {
  source  = "bcochofel/subnet/azurerm"
  version = "1.3.1"

  name                 = "snet-${var.identifier}-example"
  resource_group_name  = module.rg.name
  virtual_network_name = module.vnet.name
  address_prefixes     = ["10.5.0.0/21"]
}

resource "azurerm_private_dns_zone" "main" {
  name                = "privatelink.northeurope.azmk8s.io"
  resource_group_name = module.rg.name
}

resource "azurerm_role_assignment" "network" {
  scope                = module.rg.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.main.principal_id
}

resource "azurerm_role_assignment" "dns" {
  scope                = azurerm_private_dns_zone.main.id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.main.principal_id
}

module "aks" {
  source = "../.."

  name                = "aks${var.identifier}"
  resource_group_name = module.rg.name
  dns_prefix          = "demolab"

  default_pool_name = "default"

  user_assigned_identity_id = azurerm_user_assigned_identity.main.id

  enable_azure_active_directory   = true
  rbac_aad_managed                = true
  rbac_aad_admin_group_object_ids = [azuread_group.k8sadmins.object_id]

  private_dns_zone_id = azurerm_private_dns_zone.main.id

  node_resource_group = "aks-${var.identifier}-example"

  private_cluster_enabled = true

  availability_zones   = ["1", "2", "3"]
  enable_auto_scaling  = true
  max_pods             = 100
  orchestrator_version = "1.18.14"
  vnet_subnet_id       = module.subnet.id
  max_count            = 3
  min_count            = 1
  node_count           = 1

  enable_log_analytics_workspace = true

  network_plugin = "azure"
  network_policy = "calico"

  kubernetes_version = "1.18.14"

  only_critical_addons_enabled = true

  node_pools = [
    {
      name                 = "user1"
      availability_zones   = ["1", "2", "3"]
      enable_auto_scaling  = true
      max_pods             = 100
      orchestrator_version = "1.18.14"
      priority             = "Regular"
      max_count            = 3
      min_count            = 1
      node_count           = 1
    },
    {
      name                 = "spot1"
      max_pods             = 100
      orchestrator_version = "1.18.14"
      priority             = "Spot"
      eviction_policy      = "Delete"
      spot_max_price       = 0.5 # note: this is the "maximum" price
      node_labels = {
        "kubernetes.azure.com/scalesetpriority" = "spot"
      }
      node_taints = [
        "kubernetes.azure.com/scalesetpriority=spot:NoSchedule"
      ]
      node_count = 1
    }
  ]

  tags = {
    "ManagedBy" = "Terraform"
  }

  depends_on = [
    module.rg,
    azurerm_role_assignment.dns,
    azurerm_role_assignment.network
  ]
}

```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | n/a |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aks"></a> [aks](#module\_aks) | ../.. | n/a |
| <a name="module_rg"></a> [rg](#module\_rg) | bcochofel/resource-group/azurerm | 1.4.0 |
| <a name="module_subnet"></a> [subnet](#module\_subnet) | bcochofel/subnet/azurerm | 1.3.1 |
| <a name="module_vnet"></a> [vnet](#module\_vnet) | bcochofel/virtual-network/azurerm | 1.2.1 |

## Resources

| Name | Type |
|------|------|
| [azuread_group.k8sadmins](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group) | resource |
| [azurerm_private_dns_zone.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_role_assignment.dns](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.network](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_user_assigned_identity.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azuread_user.aad](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/user) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_identifier"></a> [identifier](#input\_identifier) | Example identifier. | `string` | `"bestpractices"` | no |
| <a name="input_location"></a> [location](#input\_location) | Location for resources. | `string` | `"North Europe"` | no |

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


## References

* [Azure AKS best practices overview](https://docs.microsoft.com/en-us/azure/aks/best-practices)
