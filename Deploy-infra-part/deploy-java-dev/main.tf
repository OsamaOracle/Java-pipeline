module "infra" {
  source            = "./modules/infra"
  region            = var.region
  env               = var.env
  cidr_block        = var.cidr_block
  web_instance_type = var.web_instance_type
  web_min           = var.web_min
  web_max           = var.web_max
  keypair           = var.keypair
}