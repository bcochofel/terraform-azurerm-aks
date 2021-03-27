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
  description = <<EOT
The FQDN for the Kubernetes Cluster when private link has been enabled, which is
only resolvable inside the Virtual Network used by the Kubernetes Cluster.
EOT
  value       = azurerm_kubernetes_cluster.aks.private_fqdn
}

output "kube_admin_config" {
  description = <<EOT
A kube_admin_config block. This is only available when Role Based Access Control
with Azure Active Directory is enabled.
EOT
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
  description = <<EOT
The auto-generated Resource Group which contains the resources for this Managed
Kubernetes Cluster.
EOT
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

output "client_key" {
  description = "Client Key"
  value       = azurerm_kubernetes_cluster.aks.kube_config[0].client_key
  sensitive   = true
}

output "client_certificate" {
  description = "Client Certificate."
  value       = azurerm_kubernetes_cluster.aks.kube_config[0].client_certificate
}

output "cluster_ca_certificate" {
  description = "Client CA Certificate."
  value       = azurerm_kubernetes_cluster.aks.kube_config[0].cluster_ca_certificate
}

output "host" {
  description = "Host"
  value       = azurerm_kubernetes_cluster.aks.kube_config[0].host
}

output "username" {
  description = "Username"
  value       = azurerm_kubernetes_cluster.aks.kube_config[0].username
}

output "password" {
  description = "Password"
  value       = azurerm_kubernetes_cluster.aks.kube_config[0].password
  sensitive   = true
}
