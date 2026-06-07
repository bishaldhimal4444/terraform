locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

# PUBLIC SUBNETS (Multi-AZ

resource "aws_subnet" "public" {
  for_each = {
    for idx, cidr in var.public_subnet_cidrs :
    idx => {
      cidr = cidr
      az   = var.availability_zones[idx]
    }
  }

  vpc_id                  = var.vpc_id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = true

  tags = {
    Name = "${local.name_prefix}-public-subnet-${each.key}"
    Tier = "public"
  }
}

# PRIVATE APP SUBNETS (EC2 / EKS / ALB backend)

resource "aws_subnet" "private_app" {
  for_each = {
    for idx, cidr in var.private_app_subnet_cidrs :
    idx => {
      cidr = cidr
      az   = var.availability_zones[idx]
    }
  }

  vpc_id            = var.vpc_id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = "${local.name_prefix}-private-app-subnet-${each.key}"
    Tier = "private-app"
  }
}

# PRIVATE DB SUBNETS (RDS Multi-AZ)

resource "aws_subnet" "private_db" {
  for_each = {
    for idx, cidr in var.private_db_subnet_cidrs :
    idx => {
      cidr = cidr
      az   = var.availability_zones[idx]
    }
  }

  vpc_id            = var.vpc_id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = "${local.name_prefix}-private-db-subnet-${each.key}"
    Tier = "private-db"
  }
}