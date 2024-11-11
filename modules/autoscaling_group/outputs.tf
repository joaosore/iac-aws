output "ecs_private_key" {
  value     = tls_private_key.ecs_key.private_key_pem
  sensitive = true
}

output "ecs_autoscaling_group_arn" {
  value = aws_autoscaling_group.ecs_autoscaling_group.arn
}

output "ecs_autoscaling_group_name" {
  value = aws_autoscaling_group.ecs_autoscaling_group.name
  description = "O nome do grupo de Auto Scaling ECS"
}

output "ec2_internal_ips" {
  value = local.ec2_internal_ips
  description = "Lista de IPs privados das instâncias EC2 no Auto Scaling Group"
}

output "ec2_internal_ids" {
  value = local.ec2_internal_ids
  description = "Lista de IDs das instâncias EC2 no Auto Scaling Group"
}