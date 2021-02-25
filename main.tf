data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

module "ssh-key" {
  source         = "./modules/ssh-key"
  public_ssh_key = var.public_ssh_key == "" ? "" : var.public_ssh_key
}

resource "azurerm_kubernetes_cluster" "aks" {
  # ignore node_count in case we are using AutoScaling
  lifecycle {
    ignore_changes = [
      default_node_pool[0].node_count,
      default_node_pool[0].tags
    ]
  }

  name                = var.name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name                         = var.default_pool_name
    vm_size                      = var.vm_size
    availability_zones           = var.availability_zones
    enable_auto_scaling          = var.enable_auto_scaling
    enable_host_encryption       = var.enable_host_encryption
    enable_node_public_ip        = var.enable_node_public_ip
    max_pods                     = var.max_pods
    node_labels                  = var.node_labels
    only_critical_addons_enabled = var.only_critical_addons_enabled
    orchestrator_version         = var.orchestrator_version
    os_disk_size_gb              = var.os_disk_size_gb
    os_disk_type                 = var.os_disk_type
    type                         = var.agent_type
    vnet_subnet_id               = var.vnet_subnet_id

    max_count  = var.enable_auto_scaling == true ? var.max_count : null
    min_count  = var.enable_auto_scaling == true ? var.min_count : null
    node_count = var.node_count

    dynamic "upgrade_settings" {
      for_each = var.max_surge == null ? [] : ["upgrade_settings"]
      content {
        max_surge = var.max_surge
      }
    }
  }

  dynamic "service_principal" {
    for_each = var.client_id != "" && var.client_secret != "" ? ["service_principal"] : []
    content {
      client_id     = var.client_id
      client_secret = var.client_secret
    }
  }

  dynamic "identity" {
    for_each = var.client_id == "" || var.client_secret == "" ? ["identity"] : []
    content {
      type                      = var.user_assigned_identity_id == "" ? "SystemAssigned" : "UserAssigned"
      user_assigned_identity_id = var.user_assigned_identity_id == "" ? null : var.user_assigned_identity_id
    }
  }

  kubernetes_version = var.kubernetes_version
}
