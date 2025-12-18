output "instance_ids" {
  description = "IDs of all EC2 instances"
  value       = aws_instance.app[*].id
}

output "instance_public_ips" {
  description = "Public IPs of all EC2 instances"
  value       = aws_instance.app[*].public_ip
}

output "backup_vault_name" {
  description = "Name of the AWS Backup vault"
  value       = aws_backup_vault.vault.name
}
