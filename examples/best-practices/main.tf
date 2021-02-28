provider "azurerm" {
  features {}
}

module "rg" {
  source  = "bcochofel/resource-group/azurerm"
  version = "1.4.0"

  name     = "rg-aks-best-practices-example"
  location = "North Europe"
}

module "vnet" {
  source  = "bcochofel/virtual-network/azurerm"
  version = "1.2.1"

  resource_group_name = module.rg.name
  name                = "vnet-best-practices-example"
  address_space       = ["10.5.0.0/16"]

  depends_on = [module.rg]
}

module "subnet" {
  source  = "bcochofel/subnet/azurerm"
  version = "1.3.1"

  name                 = "snet-best-practices-example"
  resource_group_name  = module.rg.name
  virtual_network_name = module.vnet.name
  address_prefixes     = ["10.5.0.0/21"]
}


module "aks" {
  source = "../.."

  name                = "aksbestpractices"
  resource_group_name = module.rg.name
  dns_prefix          = "demolab"

  default_pool_name = "default"

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

  depends_on = [module.rg]
}
