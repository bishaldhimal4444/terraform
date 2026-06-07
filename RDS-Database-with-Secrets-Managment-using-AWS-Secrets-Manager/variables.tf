variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"
}

variable "private_subnet_1_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "private_subnet_2_cidr" {
  type    = string
  default = "10.0.2.0/24"
}

variable "public_subnet_cidr" {
  type    = string
  default = "10.0.10.0/24"
}

variable "db_name" {
  type    = string
  default = "postgres"
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "db_instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "my_ip" {
  description = "Public IP allowed for SSH"
  type        = string
  default     = "0.0.0.0/0"
}

variable "key_pair_name" {
  type    = string
  default = "bastion-key"
}

variable "notification_email" {
  description = "Email for CloudWatch alerts"
  type        = string
}

