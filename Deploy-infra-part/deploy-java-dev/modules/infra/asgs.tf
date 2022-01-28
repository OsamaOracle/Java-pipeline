resource "aws_launch_template" "nginx_lt" {
  depends_on = [
    aws_lb.nginx_lb
  ]
  name          = "Nginx-LT"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.nginx_instance_type
  key_name      = var.keypair

  user_data = base64encode(templatefile("${path.module}/files/setup-nginx.sh", {
    alb  = aws_lb.web_lb.dns_name,
    host = "$host"
    }
  ))

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      encrypted   = false
      volume_type = "gp2"
      volume_size = "50"
    }
  }
  vpc_security_group_ids = [aws_security_group.nginx.id]
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "Nginx"
      Environment = var.env
    }
  }

  tags = {
    Name        = "Nginx-LT"
    Environment = var.env
  }
}

resource "aws_launch_template" "web_lt" {
  name          = "Webservers-LT"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.web_instance_type
  key_name      = var.keypair
  user_data     = base64encode(file("${path.module}/files/setup-web.sh"))

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      encrypted   = false
      volume_type = "gp2"
      volume_size = "50"
    }
  }
  vpc_security_group_ids = [aws_security_group.webservers.id]
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "Webservers"
      Environment = var.env
    }
  }

  tags = {
    Name        = "Webservers-LT"
    Environment = var.env
  }
}

resource "aws_autoscaling_group" "nginx_asg" {
  name                = "Nginx-ASG"
  desired_capacity    = 1
  max_size            = 3
  min_size            = 1
  target_group_arns   = [aws_lb_target_group.nginx_tg.arn]
  vpc_zone_identifier = [for subnet in aws_subnet.public_subnets[*].id : subnet]

  launch_template {
    id      = aws_launch_template.nginx_lt.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_group" "web_asg" {
  name                = "Web-ASG"
  desired_capacity    = var.web_min
  max_size            = var.web_max
  min_size            = var.web_min
  target_group_arns   = [aws_lb_target_group.web_tg.arn]
  vpc_zone_identifier = [for subnet in aws_subnet.private_subnets[*].id : subnet]

  launch_template {
    id      = aws_launch_template.web_lt.id
    version = "$Latest"
  }
}
