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
