resource "aws_security_group" "public_lb" {
  name   = "Public-LB-SG"
  vpc_id = aws_vpc.vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# resource "aws_security_group_rule" "public_lb_rule" {
#   from_port         = 443
#   protocol          = "tcp"
#   to_port           = 443
#   type              = "ingress"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = aws_security_group.public_lb.id
# }

resource "aws_security_group_rule" "public_lb_rule" {
  from_port         = 80
  protocol          = "tcp"
  to_port           = 80
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public_lb.id
}

resource "aws_security_group" "internal_lb" {
  name   = "Web-LB-SG"
  vpc_id = aws_vpc.vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "internal_lb_rule" {
  from_port                = 80
  protocol                 = "tcp"
  to_port                  = 80
  type                     = "ingress"
  source_security_group_id = aws_security_group.nginx.id
  security_group_id        = aws_security_group.internal_lb.id
}

resource "aws_security_group" "bastion" {
  name   = "Bastion-SG"
  vpc_id = aws_vpc.vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group_rule" "bastion_rule" {
  from_port         = 22
  protocol          = "tcp"
  to_port           = 22
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion.id
}

resource "aws_security_group" "nginx" {
  name   = "Nginx-SG"
  vpc_id = aws_vpc.vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "nginx_rule" {
  from_port                = 80
  protocol                 = "tcp"
  to_port                  = 80
  type                     = "ingress"
  source_security_group_id = aws_security_group.public_lb.id
  security_group_id        = aws_security_group.nginx.id
}

resource "aws_security_group_rule" "nginx_rule_ssh" {
  from_port                = 22
  protocol                 = "tcp"
  to_port                  = 22
  type                     = "ingress"
  source_security_group_id = aws_security_group.bastion.id
  security_group_id        = aws_security_group.nginx.id
}

resource "aws_security_group" "webservers" {
  name   = "Web-SG"
  vpc_id = aws_vpc.vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "webservers_rule" {
  from_port                = 80
  protocol                 = "tcp"
  to_port                  = 80
  type                     = "ingress"
  source_security_group_id = aws_security_group.internal_lb.id
  security_group_id        = aws_security_group.webservers.id
}

resource "aws_security_group_rule" "webservers_rule_ssh" {
  from_port                = 22
  protocol                 = "tcp"
  to_port                  = 22
  type                     = "ingress"
  source_security_group_id = aws_security_group.bastion.id
  security_group_id        = aws_security_group.webservers.id
}