output "public_alb" {
  value = aws_lb.nginx_lb.dns_name
}

output "bastion_ip" {
  value = aws_instance.bastion.public_ip
}

data "aws_instances" "webservers" {
  depends_on = [
    aws_autoscaling_group.web_asg
  ]
  filter {
    name   = "tag:Name"
    values = ["Webservers"]

  }
}
output "instances" {
  value = [for ip in data.aws_instances.webservers.private_ips[*] : ip]
}