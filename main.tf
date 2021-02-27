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

  linux_profile {
    admin_username = var.admin_username

    ssh_key {
      # remove any new lines using the replace interpolation function
      key_data = replace(var.public_ssh_key == "" ? module.ssh-key.public_ssh_key : var.public_ssh_key, "\n", "")
    }
  }

  addon_profile {
    aci_connector_linux {
      enabled     = var.enable_aci_connector_linux
      subnet_name = var.enable_aci_connector_linux ? var.aci_connector_linux_subnet_name : null
    }

    azure_policy {
      enabled = var.enable_azure_policy
    }

    http_application_routing {
      enabled = var.enable_http_application_routing
    }

    kube_dashboard {
      enabled = var.enabled_kube_dashboard
    }

    oms_agent {
      enabled                    = var.enable_log_analytics_workspace
      log_analytics_workspace_id = var.enable_log_analytics_workspace ? azurerm_log_analytics_workspace.main[0].id : null
    }
  }

  role_based_access_control {
    enabled = var.enable_role_based_access_control

    dynamic "azure_active_directory" {
      for_each = var.enable_role_based_access_control && var.enable_azure_active_directory && var.rbac_aad_managed ? ["rbac"] : []
      content {
        managed                = true
        admin_group_object_ids = var.rbac_aad_admin_group_object_ids
      }
    }

    dynamic "azure_active_directory" {
      for_each = var.enable_role_based_access_control && var.enable_azure_active_directory && !var.rbac_aad_managed ? ["rbac"] : []
      content {
        managed           = false
        client_app_id     = var.rbac_aad_client_app_id
        server_app_id     = var.rbac_aad_server_app_id
        server_app_secret = var.rbac_aad_server_app_secret
      }
    }
  }

  network_profile {
    network_plugin     = var.network_plugin
    network_policy     = var.network_policy
    dns_service_ip     = var.dns_service_ip
    docker_bridge_cidr = var.docker_bridge_cidr
    outbound_type      = var.outbound_type
    pod_cidr           = var.pod_cidr
    service_cidr       = var.service_cidr
    load_balancer_sku  = var.load_balancer_sku
  }

  automatic_channel_upgrade       = var.automatic_channel_upgrade
  kubernetes_version              = var.kubernetes_version
  api_server_authorized_ip_ranges = var.api_server_authorized_ip_ranges
  disk_encryption_set_id          = var.disk_encryption_set_id
  private_cluster_enabled         = var.private_cluster_enabled
  sku_tier                        = var.sku_tier

  tags = var.tags
}

resource "azurerm_log_analytics_workspace" "main" {
  count = var.enable_log_analytics_workspace ? 1 : 0

  name                = "${var.dns_prefix}-workspace"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  sku                 = var.log_analytics_workspace_sku
  retention_in_days   = var.log_retention_in_days

  tags = var.tags
}

resource "azurerm_log_analytics_solution" "main" {
  count = var.enable_log_analytics_workspace ? 1 : 0

  solution_name         = "ContainerInsights"
  location              = data.azurerm_resource_group.rg.location
  resource_group_name   = data.azurerm_resource_group.rg.name
  workspace_resource_id = azurerm_log_analytics_workspace.main[0].id
  workspace_name        = azurerm_log_analytics_workspace.main[0].name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }

  tags = var.tags
}

resource "azurerm_role_assignment" "attach_acr" {
  count = var.acr_id == "" ? 0 : 1

  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id = coalesce(var.client_id,
    azurerm_kubernetes_cluster.aks.kubelet_identity[0].user_assigned_identity_id,
    azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  )
}

module "node-pools" {
  source = "./modules/node-pools"

  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vnet_subnet_id        = var.vnet_subnet_id

  node_pools = var.node_pools
}
