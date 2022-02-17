variable "region" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "environment" {
  type = string
}

# Tagging
variable "contact_email" {
  type = string
}

variable "contact_name" {
  type = string
}
