output "s3_endpoint_id" {
  value = aws_vpc_endpoint.s3.id
}

output "ssm_endpoint_id" {
  value = aws_vpc_endpoint.ssm.id
}

output "secrets_endpoint_id" {
  value = aws_vpc_endpoint.secretsmanager.id
}

