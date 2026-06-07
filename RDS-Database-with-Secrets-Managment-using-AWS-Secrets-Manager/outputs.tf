output "vpc_id" {
  value = module.networking.vpc_id
}

output "rds_endpoint" {
  value = module.rds.db_endpoint
}

output "bastion_public_ip" {
  value = module.bastion.public_ip
}

output "db_subnet_group" {
  value = module.rds.db_subnet_group
}