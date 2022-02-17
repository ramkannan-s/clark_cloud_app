module "vpc" {
  source = "./modules/vpc"

  vpc_cidr = var.vpc_cidr

  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs

  public_subnet_azs = ["${var.region}a", "${var.region}b", "${var.region}c"]

  private_subnet_azs = ["${var.region}a", "${var.region}b", "${var.region}c"]

  public_subnet_name  = "Experiment-Public-Subnet"
  private_subnet_name = "Experiment-Private-Subnet"

  # Tags
  vpc_name      = var.vpc_name
  contact_email = var.contact_email
  contact_name  = var.contact_name
}
