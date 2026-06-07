resource "aws_db_subnet_group" "this" {
  name = "rds-subnet-group"

  subnet_ids = var.subnet_ids

  tags = {
    Name = "rds-project/rds-subnet-group"
  }
}

resource "aws_db_parameter_group" "this" {
  name   = "custom-postgres-params-dev"
  family = "postgres15"

  parameter {
    name         = "max_connections"
    value        = "200"
    apply_method = "pending-reboot"
  }

  tags = {
    Name = "rds-project/custom-postgres-params"
  }
}

resource "aws_db_instance" "this" {

  identifier           = "my-postgres-db"
  engine               = "postgres"
  engine_version       = "15"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20
  storage_type         = "gp3"
  storage_encrypted    = true
  username             = var.db_username
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.this.name
  vpc_security_group_ids = [
    var.rds_security_group_id
  ]
  parameter_group_name       = aws_db_parameter_group.this.name
  publicly_accessible        = false
  backup_retention_period    = 7
  backup_window              = "03:00-04:00"
  maintenance_window         = "Mon:04:00-Mon:05:00"
  multi_az                   = false #true
  auto_minor_version_upgrade = true
  skip_final_snapshot        = true
  deletion_protection        = false

  tags = {
    Name = "rds-project/postgres-db"
  }
}
