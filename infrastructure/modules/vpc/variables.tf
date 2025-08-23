variable "vpc_cidr" {
  description = "CIDR da VPC"
  type        = string
}

variable "azs" {
  description = "Zonas de disponibilidade"
  type        = list(string)
}

variable "environment" {
  description = "Ambiente"
  type        = string
}

variable "app_name" {
  description = "Nome da aplicação"
  type        = string
  default     = "devops-petronio-silva"
}
