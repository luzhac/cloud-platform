resource "aws_security_group" "sg" {
  name        = "${var.cluster_name}-sg"
  vpc_id      = var.vpc_id
  description = "Allow SSH and internal traffic"

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
   ingress {
    from_port   = 32345
    to_port     = 32345
    protocol    = "tcp"
    cidr_blocks = ["90.251.112.52/32"]
    description = "Allow Grafana HTTP access "
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
