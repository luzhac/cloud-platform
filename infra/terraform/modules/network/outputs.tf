output "vpc_id"            { value = aws_vpc.this.id }

output "subnet_private_id" { value = aws_subnet.private_a.id }
output "subnet_public_ids" {
  value = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]
}
