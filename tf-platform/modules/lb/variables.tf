variable "alb_subnets" {
  type = list(string)
}

variable "alb_security_grps" {
  type = list(string)
}

variable "idle_timeout" {
  type = string
}

variable "environment" {
  type = string
}

variable "alb_listener_port" {
  type = string
}

variable "alb_listener_protocol" {
  type = string
}

variable "alb_path" {
  type = list(string)
}

variable "svc_port" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "target_group_sticky" {
  type = string
}

variable "target_group_path" {
  type = string
}

variable "target_group_port" {
  type = string
}

