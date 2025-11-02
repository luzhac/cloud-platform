resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "kp" {
  key_name   = "${var.cluster_name}-key"
  public_key = tls_private_key.key.public_key_openssh
}

resource "local_file" "private_key_pem" {
  content              = tls_private_key.key.private_key_pem
  filename             = "${path.root}/.secrets/${var.cluster_name}.pem"
  file_permission      = "0400"
  directory_permission = "0700"
}
