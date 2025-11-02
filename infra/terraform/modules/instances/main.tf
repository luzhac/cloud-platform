############################################################
# Ubuntu 22.04 ARM64 AMI
############################################################
data "aws_ami" "ubuntu_arm" {
  most_recent = true
  owners      = ["099720109477"] # Canonical official account
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-arm64-server-*"]
  }
}

locals {
  ami_id = data.aws_ami.ubuntu_arm.id
}

############################################################
# EC2 Instances (Master / App / Monitor)
############################################################

# Master node
resource "aws_instance" "master" {
  ami                         = local.ami_id
  instance_type               = "t4g.small"
  subnet_id                   = var.subnet_public_id
  associate_public_ip_address = true
  vpc_security_group_ids      = [var.security_group_id]
  iam_instance_profile        = var.iam_instance_profile
  key_name                    = var.key_name



  tags = {
    Name = "${var.cluster_name}-master"
    Role = "master"
  }
}

# App node
resource "aws_instance" "app" {
  ami                         = local.ami_id
  instance_type               = "t4g.small"
  subnet_id                   = var.subnet_public_id
  associate_public_ip_address = true
  vpc_security_group_ids      = [var.security_group_id]
  iam_instance_profile        = var.iam_instance_profile
  key_name                    = var.key_name
  depends_on                  = [aws_instance.master]

  tags = {
    Name = "${var.cluster_name}-app"
    Role = "app"
  }
}

# Monitor node
resource "aws_instance" "monitor" {
  ami                         = local.ami_id
  instance_type               = "t4g.small"
  subnet_id                   = var.subnet_private_id
  associate_public_ip_address = true
  vpc_security_group_ids      = [var.security_group_id]
  iam_instance_profile        = var.iam_instance_profile
  key_name                    = var.key_name
  depends_on                  = [aws_instance.master]

  tags = {
    Name = "${var.cluster_name}-monitor"
    Role = "monitor"
  }
}

