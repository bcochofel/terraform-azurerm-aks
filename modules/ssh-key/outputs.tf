output "public_ssh_key" {
  description = "The Public SSH Key (only output a generated ssh public key)."
  value       = var.public_ssh_key != "" ? "" : tls_private_key.ssh.public_key_openssh
}
