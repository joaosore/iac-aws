variable "example_env" {
  description = "Example environment variable for the ECS task"
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

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment for resource naming and organization"
  type        = string
  default     = "dev"
}

variable "repository_name" {
  description = "Name of the ECR repository"
  type        = string
  default     = "web-enviohub-frontend"  # ou o valor desejado
}