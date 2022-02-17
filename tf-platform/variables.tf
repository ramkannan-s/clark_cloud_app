variable "environment" {
  type = string
}

variable "region" {
  type = string
}

variable "app_ami_id" {
  type = string
}

variable "bastion_ami_id" {
  type = string
}

variable "bastion_volume_size" {
  type = string
}

variable "app_volume_size" {
  type = string
}

variable "key_pair_name" {
  type = string
}

variable "bastion_instance_type" {
  type = string
}

variable "app_instance_type" {
  type = string
}

variable "bastion_instance_count" {
  type = string
}

variable "app_instance_count" {
  type = string
}
