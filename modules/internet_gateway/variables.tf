variable "vpc_id" {
  type        = string
  description = "ID da VPC onde o Internet Gateway será anexado"
}

variable "igw_name" {
  type        = string
  description = "Nome para o Internet Gateway"
}
