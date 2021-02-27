output "node_pools_ids" {
  description = "Node Pools IDs."
  value       = azurerm_kubernetes_cluster_node_pool.node_pools[*]
}
