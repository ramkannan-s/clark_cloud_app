variable "environment" {
  type = string
}

variable "app_ami_id" {
  type = string
}

variable "app_instance_type" {
  type = string
}

variable "app_volume_size" {
  type = string
}

variable "app_instance_count" {
  type = string
}

/*
variable "user_data" {
  type = string
}
*/

variable "subnet_id" {
  type = list(string)
}

variable "key_pair_name" {
  type = string
}


variable "security_group" {
  type = list(string)
}

#variable "environment" {
# type = string
#}

#variable "name" {
# type = string
#}

#variable "contact_name" {
# type = string
#}


#variable "contact_email" {
# type = string
#}


 