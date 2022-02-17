provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket = "clark-terraform-s3-west"
    key    = "platform/terraform.tfstate"
    region = "eu-west-1"
  }
}

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "clark-terraform-s3-west"
    key    = "network/terraform.tfstate"
    region = "eu-west-1"
  }
}


