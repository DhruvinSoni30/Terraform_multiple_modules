# vpc
module "vpc" {
  source = "../modules/vpc"

  cidr_block        = var.cidr_block
  cidr_block_subnet = var.cidr_block_subnet
  name              = var.name
  tenancy           = var.tenancy
}

module "ec2" {

  source = "../modules/ec2"

  ami_id            = var.ami_id
  instance_type     = var.instance_type
  region            = var.region
  subnet_id         = module.vpc.subnet_id
  name              = var.name
}
