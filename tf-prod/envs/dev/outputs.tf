output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.subnets.public_subnet_ids
}

output "private_app_subnets" {
  value = module.subnets.private_app_subnet_ids
}

output "db_security_group" {
  value = module.security.db_sg_id
}