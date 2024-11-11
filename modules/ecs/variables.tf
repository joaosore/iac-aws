variable "cluster_name" {
  description = "Name of the ECS Cluster"
  type        = string
  default     = "web-enviohub-cluster"
}

variable "execution_role_arn" {
  description = "ARN of the task execution role"
  type        = string
}

variable "subnets" {
  description = "List of subnets for ECS tasks"
  type        = list(string)
}

variable "security_group" {
  description = "Security group for ECS service"
  type        = string
}

variable "target_group_arn" {
  description = "Target group ARN for ECS service"
  type        = string
}

variable "autoscaling_group_arn" {
  description = "ARN do Auto Scaling Group para o ECS Capacity Provider"
  type        = string
}

variable "ec2_internal_ips" {
  type = list(string)
}