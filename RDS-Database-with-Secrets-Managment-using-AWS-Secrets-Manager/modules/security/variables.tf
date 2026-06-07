variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "my_ip" {
  description = "Public IP allowed to SSH into bastion"
  type        = string
}
