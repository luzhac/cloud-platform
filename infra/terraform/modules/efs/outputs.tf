output "efs_id" {
  description = "EFS File System ID"
  value       = aws_efs_file_system.this.id
}

output "efs_dns_name" {
  description = "EFS DNS name"
  value       = aws_efs_file_system.this.dns_name
}

output "efs_mount_targets" {
  description = "EFS Mount Target IDs"
  value       = [for mt in aws_efs_mount_target.this : mt.id]
}
