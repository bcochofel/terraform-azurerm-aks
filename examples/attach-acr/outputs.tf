output "name" {
  value = module.aks.name
}

output "id" {
  value = module.aks.id
}

output "fqdn" {
  value = module.aks.fqdn
}

output "private_fqdn" {
  value = module.aks.private_fqdn
}

output "kube_admin_config_raw" {
  value = module.aks.kube_admin_config_raw
}

output "kube_config_raw" {
  value = module.aks.kube_config_raw
}

output "node_resource_group" {
  value = module.aks.node_resource_group
}

output "kubelet_identity" {
  value = module.aks.kubelet_identity
}

output "identity" {
  value = module.aks.identity
}

output "acr_id" {
  value = module.acr.id
}
