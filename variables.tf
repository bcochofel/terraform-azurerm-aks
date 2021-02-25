variable "resource_group_name" {
  description = <<EOT
The name of the resource group in which to create the AKS.
The Resource Group must already exist.
EOT
  type        = string
}

variable "public_ssh_key" {
  description = <<EOT
The Public SSH Key used to access the cluster.
Changing this forces a new resource to be created.
EOT
  type        = string
  default     = ""
}

variable "name" {
  description = <<EOT
The name of the Managed Kubernetes Cluster to create.
Changing this forces a new resource to be created.
EOT
  type        = string
}
