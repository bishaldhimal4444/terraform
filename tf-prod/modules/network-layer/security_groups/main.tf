locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

# 1. Web SG (Internet-facing)

resource "aws_security_group" "web" {
  name        = "${local.name_prefix}-web-sg"
  description = "Web tier security group"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${local.name_prefix}-web-sg"
    Tier = "web"
  }
}

# Web Ingress Rules
resource "aws_vpc_security_group_ingress_rule" "web_http" {
  security_group_id = aws_security_group.web.id

  ip_protocol = "tcp"
  from_port   = 80
  to_port     = 80

  cidr_ipv4 = "0.0.0.0/0"
}
resource "aws_vpc_security_group_ingress_rule" "web_https" {
  security_group_id = aws_security_group.web.id

  ip_protocol = "tcp"
  from_port   = 443
  to_port     = 443

  cidr_ipv4 = "0.0.0.0/0"
}


# SSH (restricted)

resource "aws_vpc_security_group_ingress_rule" "web_ssh" {
  security_group_id = aws_security_group.web.id

  ip_protocol = "tcp"
  from_port   = 22
  to_port     = 22

  cidr_ipv4 = var.allowed_ssh_cidr
}

# Web Egress

resource "aws_vpc_security_group_egress_rule" "web_all" {
  security_group_id = aws_security_group.web.id

  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"
}

# 2. App SG (internal only)

resource "aws_security_group" "app" {
  name        = "${local.name_prefix}-app-sg"
  description = "Application tier security group"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${local.name_prefix}-app-sg"
    Tier = "app"
  }
}

#App ingress ONLY from Web SG
resource "aws_vpc_security_group_ingress_rule" "app_from_web" {
  security_group_id = aws_security_group.app.id

  ip_protocol = "tcp"
  from_port   = 0
  to_port     = 65535

  referenced_security_group_id = aws_security_group.web.id
}

# App egress
resource "aws_vpc_security_group_egress_rule" "app_all" {
  security_group_id = aws_security_group.app.id

  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"
}

# 3. DB SG (strictly private)

resource "aws_security_group" "db" {
  name        = "${local.name_prefix}-db-sg"
  description = "Database tier security group"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${local.name_prefix}-db-sg"
    Tier = "db"
  }
}

# DB ingress ONLY from APP SG
resource "aws_vpc_security_group_ingress_rule" "db_from_app" {
  security_group_id = aws_security_group.db.id

  ip_protocol = "tcp"
  from_port   = 5432
  to_port     = 5432

  referenced_security_group_id = aws_security_group.app.id
}

# DB egress (optional minimal)
resource "aws_vpc_security_group_egress_rule" "db_all" {
  security_group_id = aws_security_group.db.id

  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"
}

