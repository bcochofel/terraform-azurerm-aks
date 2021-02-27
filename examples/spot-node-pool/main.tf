provider "azurerm" {
  features {}
}

module "rg" {
  source  = "bcochofel/resource-group/azurerm"
  version = "1.4.0"

  name     = "rg-aks-spot-node-pool-example"
  location = "North Europe"
}

module "aks" {
  source = "../.."

  name                = "aksspotexample"
  resource_group_name = module.rg.name
  dns_prefix          = "demolab"

  default_pool_name = "default"

  node_pools = [
    {
      name            = "spot"
      priority        = "Spot"
      eviction_policy = "Delete"
      spot_max_price  = 0.5 # note: this is the "maximum" price
      node_labels = {
        "kubernetes.azure.com/scalesetpriority" = "spot"
      }
      node_taints = [
        "kubernetes.azure.com/scalesetpriority=spot:NoSchedule"
      ]
      node_count = 1
    }
  ]

  depends_on = [module.rg]
}
