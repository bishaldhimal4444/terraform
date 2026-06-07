# 1. VPC MODULE
module "vpc" {
  source = "../../modules/network-layer/vpc"

  project_name = var.project_name
  environment  = var.environment
  vpc_cidr     = var.vpc_cidr
}

# 2. SUBNET MODULE
module "subnets" {
  source = "../../modules/network-layer/subnets"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.vpc.vpc_id

  public_subnet_cidrs      = var.public_subnet_cidrs
  private_app_subnet_cidrs = var.private_app_subnet_cidrs
  private_db_subnet_cidrs  = var.private_db_subnet_cidrs

  availability_zones = var.availability_zones
}

# 3. NAT MODULE
module "nat" {
  source = "../../modules/network-layer/nat"

  project_name = var.project_name
  environment  = var.environment

  public_subnet_ids = module.subnets.public_subnet_ids

  private_route_table_ids = module.route_tables.private_route_table_ids
}

# 4. ROUTE TABLE MODULE
module "route_tables" {
  source = "../../modules/network-layer/route_tables"

  project_name = var.project_name
  environment  = var.environment

  vpc_id               = module.vpc.vpc_id
  internet_gateway_id  = module.vpc.igw_id
  nat_gateway_ids      = module.nat.nat_gateway_ids

  public_subnet_ids    = module.subnets.public_subnet_ids
  private_app_subnet_ids = module.subnets.private_app_subnet_ids
}

# 5. SECURITY MODULE
module "security" {
  source = "../../modules/security/security_groups"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.vpc.vpc_id

  allowed_ssh_cidr = var.allowed_ssh_cidr
}

# 6. IAM MODULE
module "iam" {
  source = "../../modules/security/iam"

  project_name = var.project_name
  environment  = var.environment
}

