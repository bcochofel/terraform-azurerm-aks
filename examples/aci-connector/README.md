# AKS cluster with ACI Virtual Nodes

This example deploys a AKS cluster with ACI Virtual Nodes

If you have not previously used ACI, register the service provider with your subscription. You can check the status of the ACI provider registration using the az provider list command, as shown in the following example:

```bash
az provider list --query "[?contains(namespace,'Microsoft.ContainerInstance')]" -o table
```

The Microsoft.ContainerInstance provider should report as Registered, as shown in the following example output:
Output

```bash
Namespace                    RegistrationState    RegistrationPolicy
---------------------------  -------------------  --------------------
Microsoft.ContainerInstance  Registered           RegistrationRequired
```

If the provider shows as NotRegistered, register the provider using the az provider register as shown in the following example:
Azure CLI

```bash
az provider register --namespace Microsoft.ContainerInstance
```

To deploy an application you can use the following example:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: aci-helloworld
spec:
  replicas: 1
  selector:
    matchLabels:
      app: aci-helloworld
  template:
    metadata:
      labels:
        app: aci-helloworld
    spec:
      containers:
      - name: aci-helloworld
        image: mcr.microsoft.com/azuredocs/aci-helloworld
        ports:
        - containerPort: 80
      nodeSelector:
        kubernetes.io/role: agent
        beta.kubernetes.io/os: linux
        type: virtual-kubelet
      tolerations:
      - key: virtual-kubelet.io/provider
        operator: Exists
      - key: azure.com/aci
        effect: NoSchedule
```

## Usage

```hcl:examples/aci-connector/main.tf
provider "azurerm" {
  features {}
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

resource "azurerm_subnet" "example-aci" {
  name                 = "snet-aci-example"
  resource_group_name  = module.rg.name
  virtual_network_name = module.vnet.name
  address_prefixes     = ["10.5.8.0/24"]

  delegation {
    name = "aciDelegation"
    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource "azurerm_role_assignment" "network" {
  scope                = module.rg.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.main.principal_id
}

module "aks" {
  source = "../.."

  name                = "aks${var.identifier}"
  resource_group_name = module.rg.name
  dns_prefix          = "demolab"

  default_pool_name = "default"

  user_assigned_identity_id = azurerm_user_assigned_identity.main.id

  node_resource_group = "aks-${var.identifier}-example"

  enable_auto_scaling  = true
  orchestrator_version = "1.18.14"
  vnet_subnet_id       = module.subnet.id
  max_count            = 3
  min_count            = 1
  node_count           = 1

  enable_aci_connector_linux      = true
  aci_connector_linux_subnet_name = azurerm_subnet.example-aci.name

  enable_log_analytics_workspace = true

  network_plugin = "azure"
  network_policy = "calico"

  kubernetes_version = "1.18.14"

  tags = {
    "ManagedBy" = "Terraform"
  }

  depends_on = [
    module.rg,
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
| azurerm | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| aks | ../.. |  |
| rg | bcochofel/resource-group/azurerm | 1.4.0 |
| subnet | bcochofel/subnet/azurerm | 1.3.1 |
| vnet | bcochofel/virtual-network/azurerm | 1.2.1 |

## Resources

| Name |
|------|
| [azurerm_role_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) |
| [azurerm_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) |
| [azurerm_user_assigned_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| identifier | Example identifier. | `string` | `"aciconnector"` | no |
| location | Location for resources. | `string` | `"North Europe"` | no |

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


## References

* [Azure AKS use Virtual Nodes](https://docs.microsoft.com/en-us/azure/aks/virtual-nodes)
* [Azure AKS create cluster](https://docs.microsoft.com/en-us/azure/aks/virtual-nodes-cli)
