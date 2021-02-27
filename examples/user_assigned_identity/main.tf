provider "azurerm" {
  features {}
}

module "rg" {
  source  = "bcochofel/resource-group/azurerm"
  version = "1.4.0"

  name     = "rg-aks-basic-example"
  location = "North Europe"
}

resource "azurerm_user_assigned_identity" "aks_identity" {
  resource_group_name = module.rg.name
  location            = module.rg.location

  name = "aks_identity"
}

module "aks" {
  source = "../.."

  name                = "aksuserassignedexample"
  resource_group_name = module.rg.name
  dns_prefix          = "demolab"

  default_pool_name = "default"

  user_assigned_identity_id = azurerm_user_assigned_identity.aks_identity.id

  depends_on = [module.rg]
}
