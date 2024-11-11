variable "vpc_id" {
  description = "ID da AMI para instâncias EC2"
  type        = string
}

variable "key_name" {
  description = "Nome da chave SSH"
  type        = string
  default     = ""  # Valor padrão vazio
}

variable "ami_id" {
  description = "ID da AMI para instâncias EC2"
  type        = string
  default     = ""  # Valor padrão vazio
}

variable "sg_name" {
  description = "Nome do security group"
  type        = string
}