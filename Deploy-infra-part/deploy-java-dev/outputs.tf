output "public_alb" {
  value = module.infra.public_alb
}

output "bastion" {
  value = module.infra.bastion_ip
}

output "instances" {
  value = module.infra.instances
}