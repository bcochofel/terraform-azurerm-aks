locals {
  spot_node_pools = {
    for n in var.node_pools :
    n.name => {
      name                   = n.name
      vm_size                = lookup(n, "vm_size", var.vm_size)
      availability_zones     = lookup(n, "availability_zones", var.availability_zones)
      enable_auto_scaling    = lookup(n, "enable_auto_scaling", var.enable_auto_scaling)
      enable_host_encryption = false
      enable_node_public_ip  = lookup(n, "enable_node_public_ip", var.enable_node_public_ip)
      eviction_policy        = lookup(n, "eviction_policy", var.eviction_policy)
      max_pods               = lookup(n, "max_pods", var.max_pods)
      mode                   = lookup(n, "mode", var.mode)
      node_labels            = lookup(n, "node_labels", var.node_labels)
      node_taints            = lookup(n, "node_taints", var.node_taints)
      orchestrator_version   = lookup(n, "orchestrator_version", var.orchestrator_version)
      os_disk_size_gb        = lookup(n, "os_disk_size_gb", var.os_disk_size_gb)
      os_disk_type           = lookup(n, "os_disk_type", var.os_disk_type)
      os_type                = lookup(n, "os_type", var.os_type)
      priority               = lookup(n, "priority", var.priority)
      spot_max_price         = lookup(n, "spot_max_price", var.spot_max_price)
      tags                   = lookup(n, "tags", var.tags)
      max_count              = lookup(n, "max_count", var.max_count)
      min_count              = lookup(n, "min_count", var.min_count)
      node_count             = lookup(n, "node_count", var.node_count)
      max_surge              = lookup(n, "max_surge", var.max_surge)
    } if n.priority == "Spot"
  }

  regular_node_pools = {
    for n in var.node_pools :
    n.name => {
      name                   = n.name
      vm_size                = lookup(n, "vm_size", var.vm_size)
      availability_zones     = lookup(n, "availability_zones", var.availability_zones)
      enable_auto_scaling    = lookup(n, "enable_auto_scaling", var.enable_auto_scaling)
      enable_host_encryption = false
      enable_node_public_ip  = lookup(n, "enable_node_public_ip", var.enable_node_public_ip)
      max_pods               = lookup(n, "max_pods", var.max_pods)
      mode                   = lookup(n, "mode", var.mode)
      node_labels            = lookup(n, "node_labels", var.node_labels)
      node_taints            = lookup(n, "node_taints", var.node_taints)
      orchestrator_version   = lookup(n, "orchestrator_version", var.orchestrator_version)
      os_disk_size_gb        = lookup(n, "os_disk_size_gb", var.os_disk_size_gb)
      os_disk_type           = lookup(n, "os_disk_type", var.os_disk_type)
      os_type                = lookup(n, "os_type", var.os_type)
      priority               = lookup(n, "priority", var.priority)
      tags                   = lookup(n, "tags", var.tags)
      max_count              = lookup(n, "max_count", var.max_count)
      min_count              = lookup(n, "min_count", var.min_count)
      node_count             = lookup(n, "node_count", var.node_count)
      max_surge              = lookup(n, "max_surge", var.max_surge)
    } if n.priority == "Regular"
  }
}
