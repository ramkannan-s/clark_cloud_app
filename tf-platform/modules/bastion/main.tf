
resource "aws_instance" "bastion_server" {
  count = "${var.environment == "dev" ? "1" : "0"}"
  #count                  = var.bastion_instance_count
  ami                    = var.bastion_ami_id
  instance_type          = var.bastion_instance_type
  key_name               = var.key_pair_name
  subnet_id              = element(var.subnet_id, count.index)
  vpc_security_group_ids = var.security_group
  root_block_device {
    volume_size           = var.bastion_volume_size
    volume_type           = "gp2"
    delete_on_termination = true
  }
  tags = {
    Name    = "Bastion-Server"
    AutoOff = "True"
    AutoOn  = "True"
  }
}

/*resource "aws_eip" "eip" {
  instance = aws_instance.bastion_server.0.id
  vpc      = true
}*/

