output "name" {
  description = "The Kubernetes Managed Cluster name."
  value       = azurerm_kubernetes_cluster.aks.name
}

output "id" {
  description = "The Kubernetes Managed Cluster ID."
  value       = azurerm_kubernetes_cluster.aks.id
}

output "fqdn" {
  description = "The FQDN of the Azure Kubernetes Managed Cluster."
  value       = azurerm_kubernetes_cluster.aks.fqdn
}

output "private_fqdn" {
  description = "The FQDN for the Kubernetes Cluster when private link has been enabled, which is only resolvable inside the Virtual Network used by the Kubernetes Cluster."
  value       = azurerm_kubernetes_cluster.aks.private_fqdn
}

output "kube_admin_config" {
  description = "A kube_admin_config block. This is only available when Role Based Access Control with Azure Active Directory is enabled."
  value       = azurerm_kubernetes_cluster.aks.kube_admin_config
}

output "kube_admin_config_raw" {
  description = <<EOT
Raw Kubernetes config for the admin account to be used by kubectl and other
compatible tools. This is only available when Role Based Access Control with
Azure Active Directory is enabled.
EOT
  value       = azurerm_kubernetes_cluster.aks.kube_admin_config_raw
}

output "kube_config" {
  description = "A kube_config block."
  value       = azurerm_kubernetes_cluster.aks.kube_config
}

output "kube_config_raw" {
  description = <<EOT
Raw Kubernetes config to be used by kubectl and other compatible tools
EOT
  value       = azurerm_kubernetes_cluster.aks.kube_config_raw
}

output "node_resource_group" {
  description = "The auto-generated Resource Group which contains the resources for this Managed Kubernetes Cluster."
  value       = azurerm_kubernetes_cluster.aks.node_resource_group
}

output "kubelet_identity" {
  description = "A kubelet_identity block"
  value       = azurerm_kubernetes_cluster.aks.kubelet_identity
}

output "identity" {
  description = "A identity block"
  value       = azurerm_kubernetes_cluster.aks.identity
}
