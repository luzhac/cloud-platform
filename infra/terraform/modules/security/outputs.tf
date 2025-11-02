output "security_group_id" {
  value = aws_security_group.sg.id
}

output "security_group_efs_id" {
  value = aws_security_group.efs_sg.id
}

