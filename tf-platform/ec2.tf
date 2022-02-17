
#data "template_file" "userdata" {
# template = file("install.sh")
#}

/*module "app" {
  source = "./modules/app-server"

  app_instance_count = var.app_instance_count
  app_ami_id         = var.app_ami_id
  app_instance_type  = var.app_instance_type
  key_pair_name      = var.key_pair_name
  subnet_id          = data.terraform_remote_state.network.outputs.private_subnet_ids
  #user_data     = data.template_file.userdata.rendered
  app_volume_size = var.app_volume_size
  security_group  = [aws_security_group.app.id]
  environment     = var.environment

} */


module "bastion" {
  source = "./modules/bastion"

  bastion_instance_count = var.bastion_instance_count
  environment            = var.environment
  bastion_ami_id         = var.bastion_ami_id
  bastion_instance_type  = var.bastion_instance_type
  key_pair_name          = var.key_pair_name
  subnet_id              = data.terraform_remote_state.network.outputs.public_subnet_ids
  security_group         = [aws_security_group.bastion.id]
  bastion_volume_size    = var.bastion_volume_size

}
