resource "azurerm_kubernetes_cluster_node_pool" "spot" {
  for_each = local.spot_node_pools

  lifecycle {
    ignore_changes = [
      node_count,
      tags
    ]
  }

  kubernetes_cluster_id = var.kubernetes_cluster_id
  vnet_subnet_id        = var.vnet_subnet_id

  name                   = each.value.name
  vm_size                = each.value.vm_size
  availability_zones     = each.value.availability_zones
  enable_auto_scaling    = each.value.enable_auto_scaling
  enable_host_encryption = each.value.enable_host_encryption
  enable_node_public_ip  = each.value.enable_node_public_ip
  eviction_policy        = each.value.eviction_policy
  max_pods               = each.value.max_pods
  mode                   = each.value.mode
  node_labels            = each.value.node_labels
  node_taints            = each.value.node_taints
  orchestrator_version   = each.value.orchestrator_version
  os_disk_size_gb        = each.value.os_disk_size_gb
  os_disk_type           = each.value.os_disk_type
  os_type                = each.value.os_type
  priority               = each.value.priority
  spot_max_price         = each.value.spot_max_price
  tags                   = each.value.tags
  max_count              = each.value.max_count
  min_count              = each.value.min_count
  node_count             = each.value.node_count

  dynamic "upgrade_settings" {
    for_each = var.max_surge == null ? [] : ["upgrade_settings"]
    content {
      max_surge = each.value.max_surge
    }
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "regular" {
  for_each = local.regular_node_pools

  lifecycle {
    ignore_changes = [
      node_count,
      tags
    ]
  }

  kubernetes_cluster_id = var.kubernetes_cluster_id
  vnet_subnet_id        = var.vnet_subnet_id

  name                   = each.value.name
  vm_size                = each.value.vm_size
  availability_zones     = each.value.availability_zones
  enable_auto_scaling    = each.value.enable_auto_scaling
  enable_host_encryption = each.value.enable_host_encryption
  enable_node_public_ip  = each.value.enable_node_public_ip
  max_pods               = each.value.max_pods
  mode                   = each.value.mode
  node_labels            = each.value.node_labels
  node_taints            = each.value.node_taints
  orchestrator_version   = each.value.orchestrator_version
  os_disk_size_gb        = each.value.os_disk_size_gb
  os_disk_type           = each.value.os_disk_type
  os_type                = each.value.os_type
  priority               = each.value.priority
  tags                   = each.value.tags
  max_count              = each.value.max_count
  min_count              = each.value.min_count
  node_count             = each.value.node_count

  dynamic "upgrade_settings" {
    for_each = var.max_surge == null ? [] : ["upgrade_settings"]
    content {
      max_surge = each.value.max_surge
    }
  }
}
