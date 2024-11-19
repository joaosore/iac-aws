variable "subnets" {
  description = "List of subnet IDs for the load balancer"
  type        = list(string)
}

variable "security_group_id_public" {
  description = "Security group ID for the load balancer"
  type        = string
}

variable "security_group_id_private" {
  description = "Security group ID for the load balancer"
  type        = string
}

variable "vpc_id" {
  description = "ID da VPC para o load balancer"
  type        = string
}

# output "my_target_group_arn" {
#   value       = aws_lb_target_group.ecs_target_group.arn
#   description = "ARN do Target Group para o Auto Scaling Group"
# }