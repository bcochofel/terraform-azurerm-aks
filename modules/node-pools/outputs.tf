output "spot_node_pools_ids" {
  description = "Spot priority Node Pools IDs."
  value       = azurerm_kubernetes_cluster_node_pool.spot[*]
}

output "regular_node_pools_ids" {
  description = "Regular priority Node Pools IDs."
  value       = azurerm_kubernetes_cluster_node_pool.regular[*]
}
