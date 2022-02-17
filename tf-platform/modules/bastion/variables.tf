
variable "bastion_ami_id" {
  type = string
}

variable "bastion_instance_type" {
  type = string
}

variable "bastion_instance_count" {
  type = string
}

variable "environment" {
  type = string
}

variable "bastion_volume_size" {
  type = string
}

variable "key_pair_name" {
  type = string
}

variable "subnet_id" {
  type = list(string)
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
# type = "string"
#}


#variable "contact_email" {
# type = "string"
#}


 