provider "azurerm" {
  features {}
}

module "rg" {
  source  = "bcochofel/resource-group/azurerm"
  version = "1.4.0"

  name     = "rg-aks-calico-example"
  location = "North Europe"
}

module "aks" {
  source = "../.."

  name                = "akscalicoexample"
  resource_group_name = module.rg.name
  dns_prefix          = "demolab"

  default_pool_name = "default"

  network_plugin = "azure"
  network_policy = "calico"

  depends_on = [module.rg]
}
