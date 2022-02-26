
#module "elb" {
#  source = "./modules/lb"

#  security_group = aws_security_group.instance.id
#  az             = data.aws_availability_zones.all.names
#  ami_id         = ami-0f29c8402f8cce65c
#} 

module "asg" {
  source = "./modules/asg"

  #az = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  # subnet_id          = data.terraform_remote_state.network.outputs.private_subnet_ids
  vpc_zone_identifier = data.terraform_remote_state.network.outputs.private_subnet_ids
  app_ami_id          = var.app_ami_id
  security_group      = [aws_security_group.asg.id]
  key_name            = var.key_pair_name
  environment         = var.environment
  target_group_arns   = [module.alb.alb_tg_arn]
  app_instance_count  = var.app_instance_count
}

module "alb" {
  source = "./modules/lb"

  alb_subnets           = data.terraform_remote_state.network.outputs.public_subnet_ids
  idle_timeout          = "3500"
  alb_security_grps     = [aws_security_group.alb.id]
  alb_listener_port     = "80"
  alb_listener_protocol = "HTTP"
  alb_path              = ["/"]
  svc_port              = "8080"
  vpc_id                = data.terraform_remote_state.network.outputs.vpc_id
  target_group_sticky   = "false"
  target_group_path     = "/hello/"
  target_group_port     = "8500"
  environment           = var.environment
}
