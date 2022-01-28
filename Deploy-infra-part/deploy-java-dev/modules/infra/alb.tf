resource "aws_lb_target_group" "nginx_tg" {
  vpc_id   = aws_vpc.vpc.id
  name     = "Nginx-tg"
  port     = 80
  protocol = "HTTP"
  health_check {
    port     = 80
    protocol = "HTTP"
    path     = "/healthstatus"
  }
}

resource "aws_lb_target_group" "web_tg" {
  vpc_id   = aws_vpc.vpc.id
  name     = "Web-tg"
  port     = 80
  protocol = "HTTP"
  health_check {
    port     = 80
    protocol = "HTTP"
    path     = "/healthstatus"
  }
}

# add nginx lb and target group

resource "aws_lb" "nginx_lb" {
  name               = "Nginx-lb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.public_lb.id]
  subnets            = [for subnet in aws_subnet.public_subnets[*].id : subnet]

  enable_deletion_protection = false

  tags = {
    Environment = var.env
  }
}

resource "aws_lb" "web_lb" {
  name               = "Web-lb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.internal_lb.id]
  subnets            = [for subnet in aws_subnet.private_subnets[*].id : subnet]

  enable_deletion_protection = false

  tags = {
    Environment = var.env
  }
}

# resource "aws_lb_listener" "redirect" {
#   load_balancer_arn = aws_lb.nginx_lb.arn
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     type             = "redirect"
#     status_code      = "HTTP_301"
#     port             = 443
#     protocol         = "HTTPS"
#   }

# }

resource "aws_lb_listener" "nginx" {
  load_balancer_arn = aws_lb.nginx_lb.arn
  port              = "80"
  protocol          = "HTTP"
  # certificate_arn   = aws_acm_certificate_validation.validation.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx_tg.arn
  }
}

resource "aws_lb_listener" "web" {
  load_balancer_arn = aws_lb.web_lb.arn
  port              = "80"
  protocol          = "HTTP"
  # certificate_arn   = aws_acm_certificate_validation.validation.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}