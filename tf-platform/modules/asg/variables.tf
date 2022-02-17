variable "security_group" {
  type = list(any)
}

variable "key_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "app_ami_id" {
  type = string
}

variable "vpc_zone_identifier" {
  type = list(string)
}

variable "target_group_arns" {
  type = list(string)
}

