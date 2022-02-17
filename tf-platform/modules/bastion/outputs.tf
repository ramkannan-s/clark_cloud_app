output "instance_ids" {
  value = aws_instance.bastion_server.*.id
}