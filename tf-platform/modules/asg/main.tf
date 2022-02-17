data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami*amazon-ecs-optimized"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["amazon", "self"]
}

## Creating Launch Configuration
resource "aws_launch_configuration" "example" {
  name = "web_instance_${var.environment}"
  #image_id        = data.aws_ami.amazon_linux.id
  image_id        = var.app_ami_id
  instance_type   = "t2.micro"
  security_groups = var.security_group
  key_name        = var.key_name
  user_data       = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              service httpd start
              chkconfig httpd on
              echo “Hello World from $(hostname -f)” > /var/www/html/index.html &
              EOF
  lifecycle {
    create_before_destroy = true
  }

}
## Creating AutoScaling Group
resource "aws_autoscaling_group" "example" {
  launch_configuration = aws_launch_configuration.example.name
  vpc_zone_identifier  = var.vpc_zone_identifier
  #availability_zones   = var.az
  min_size          = 3
  max_size          = 3
  target_group_arns = var.target_group_arns
  health_check_type = "ELB"
  tag {
    key                 = "Name"
    value               = "web_instance_${var.environment}"
    propagate_at_launch = true
  }
}
