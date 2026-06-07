module "networking" {
  source = "./modules/networking"

  vpc_cidr              = var.vpc_cidr
  private_subnet_1_cidr = var.private_subnet_1_cidr
  private_subnet_2_cidr = var.private_subnet_2_cidr
  public_subnet_cidr    = var.public_subnet_cidr
}

module "security" {
  source = "./modules/security"

  vpc_id = module.networking.vpc_id
  my_ip  = var.my_ip
}

module "rds" {
  source = "./modules/rds"

  db_username = var.db_username
  db_password = var.db_password

  subnet_ids = [
    module.networking.private_subnet_1_id,
    module.networking.private_subnet_2_id
  ]

  rds_security_group_id = module.security.rds_sg_id
}

module "bastion" {

  source = "./modules/bastion"

  public_subnet_id = module.networking.public_subnet_id

  bastion_sg_id = module.security.bastion_sg_id

  key_pair_name = var.key_pair_name
}

module "monitoring" {

  source = "./modules/monitoring"

  db_instance_id = module.rds.db_instance_id

  notification_email = var.notification_email
}

