variable "vpc_id" {
  type        = string
  description = "ID da VPC para a tabela de rotas"
}

variable "igw_id" {
  type        = string
  description = "ID do Internet Gateway para a rota de internet"
}

variable "subnet_ids" {
  type        = list(string)
  description = "ID da subnet para associar a tabela de rotas"
}

variable "route_table_name" {
  type        = string
  description = "Nome para a tabela de rotas"
}
