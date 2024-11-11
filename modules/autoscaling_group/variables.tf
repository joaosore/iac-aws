variable "subnets" {
  description = "List of subnets for the EC2 instances"
  type        = list(string)
}

variable "target_group_arn" {
  description = "ARN do Target Group para registrar instâncias"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the EC2 instances"
  type        = string
}

variable "security_group_ids" {
  description = "List of security group IDs to attach to the instances"
  type        = list(string)
}

variable "ecs_cluster_name" {
  description = "Nome do cluster ECS"
  type        = string
}