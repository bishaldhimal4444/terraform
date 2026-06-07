
locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

# PUBLIC ROUTE TABLE - 1 

resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${local.name_prefix}-public-rt"
    Tier = "public"
  }
}

# Internet route (IGW)

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.internet_gateway_id
}

# Public subnet associations

resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_ids)

  subnet_id      = var.public_subnet_ids[count.index]
  route_table_id = aws_route_table.public.id
}

# PRIVATE ROUTE TABLES (PER AZ)

resource "aws_route_table" "private" {
  count  = length(var.private_app_subnet_ids)
  vpc_id = var.vpc_id

  tags = {
    Name = "${local.name_prefix}-private-rt-${count.index}"
    Tier = "private"
  }
}

# NAT ROUTES (per AZ)
resource "aws_route" "private_nat" {
  count = length(var.nat_gateway_ids)

  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.nat_gateway_ids[count.index]
}

# PRIVATE SUBNET ASSOCIATIONS

resource "aws_route_table_association" "private" {
  count = length(var.private_app_subnet_ids)

  subnet_id = var.private_app_subnet_ids[count.index]

  route_table_id = aws_route_table.private[
    count.index % length(aws_route_table.private)
  ].id
}

# Component	Count
# Public Route Table	1
# Private Route Tables	2
# Public Routes	1
# Private NAT Routes	2
# Associations	multiple