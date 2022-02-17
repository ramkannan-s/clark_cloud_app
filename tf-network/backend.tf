terraform {
  backend "s3" {
    bucket = "clark-terraform-s3-west"
    key    = "network/terraform.tfstate"
    region = "eu-west-1"
  }
}