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
