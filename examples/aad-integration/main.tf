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
