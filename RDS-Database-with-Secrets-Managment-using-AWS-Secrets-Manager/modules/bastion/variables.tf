variable "public_subnet_id" {
  description = "Public subnet for bastion host"
  type        = string
}

variable "bastion_sg_id" {
  description = "Security group for bastion"
  type        = string
}

variable "key_pair_name" {
  description = "EC2 key pair name"
  type        = string
}