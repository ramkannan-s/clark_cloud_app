region = "eu-west-1" # "ap-south-1"

environment = "dev"

app_ami_id = "ami-08ca3fed11864d6bb" # "ami-0851b76e8b1bce90b"

bastion_ami_id = "ami-04f5641b0d178a27a" # "ami-002d6833390304363"

bastion_instance_type = "t2.large"

app_instance_type = "t3.micro"

key_pair_name = "experiment-clark-key-pair"

bastion_instance_count = "1"

app_instance_count = "3"

app_volume_size = "15"

bastion_volume_size = "10"
