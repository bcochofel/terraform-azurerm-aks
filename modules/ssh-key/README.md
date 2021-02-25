# ssh-key

Module to handle Public SSH Key.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| local | n/a |
| tls | n/a |

## Modules

No Modules.

## Resources

| Name |
|------|
| [local_file](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) |
| [tls_private_key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| public\_ssh\_key | The Public SSH Keys used to access the cluster. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| public\_ssh\_key | The Public SSH Key (only output a generated ssh public key). |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
