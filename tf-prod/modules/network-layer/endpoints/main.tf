locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

# S3 VPC ENDPOINT (Gateway Type)

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = var.vpc_id
  service_name = "com.amazonaws.${data.aws_region.current.name}.s3"

  route_table_ids = var.private_route_table_ids

  tags = {
    Name = "${local.name_prefix}-s3-endpoint"
  }
}

data "aws_region" "current" {}

# SSM VPC ENDPOINT (Interface Type)

resource "aws_vpc_endpoint" "ssm" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.ssm"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.subnet_ids
  private_dns_enabled = true

  security_group_ids = []

  tags = {
    Name = "${local.name_prefix}-ssm-endpoint"
  }
}

# SECRETS MANAGER ENDPOINT

resource "aws_vpc_endpoint" "secretsmanager" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.secretsmanager"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.subnet_ids
  private_dns_enabled = true

  tags = {
    Name = "${local.name_prefix}-secrets-endpoint"
  }
}

# CLOUDWATCH LOGS ENDPOINT

resource "aws_vpc_endpoint" "logs" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.logs"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.subnet_ids
  private_dns_enabled = true

  tags = {
    Name = "${local.name_prefix}-logs-endpoint"
  }
}

# Endpoint-Type	-> Purpose
# S3 Gateway	-> storage access
# SSM Interface	-> server management
# Secrets Manager	-> credentials
# CloudWatch Logs	-> logging 