resource "aws_instance" "app_server" {

  count                  = var.app_instance_count
  ami                    = var.app_ami_id
  instance_type          = var.app_instance_type
  key_name               = var.key_pair_name
  subnet_id              = element(var.subnet_id, count.index)
  vpc_security_group_ids = var.security_group
  #user_data               = var.user_data

  root_block_device {
    volume_size           = var.app_volume_size
    volume_type           = "gp2"
    delete_on_termination = true
  }
  tags = {
    Name        = "web_instance"
    environment = var.environment
    AutoOff     = "True"
    AutoOn      = "True"
    Group       = "web_instance",
  }

}

#resource "aws_ebs_volume" "app_ebs" {
# count      = var.app_instance_count
#availability_zone = element(aws_instance.app_server.*.availability_zone, count.index)
#size      = 1
#tags = {
# Name = "App-EBS-${count.index +1}"
#}
#}

#resource "aws_volume_attachment" "ebs_att" {
# count       =  var.app_instance_count
#device_name = "/dev/xvdb"
#volume_id   = aws_ebs_volume.app_ebs[count.index].id
#instance_id = aws_instance.app_server[count.index].id
#}
