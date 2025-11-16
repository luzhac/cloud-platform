resource "aws_lb" "ingress" {
  name               = "ingress-nginx-alb"
  load_balancer_type = "application"
  internal           = false

  subnets         = var.public_subnets
  security_groups = [var.security_group_id]
}
