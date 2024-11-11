output "public_subnet_ids" {
  value = [for subnet in aws_subnet.public : subnet.id]
  description = "IDs das subnets públicas"
}

output "private_subnet_ids" {
  value = [for subnet in aws_subnet.private : subnet.id]
  description = "IDs das subnets privadas"
}