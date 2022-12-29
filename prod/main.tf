module "vpc" {
  source = "../modules/vpc"

  cidr_block        = var.cidr_block
  vpc_id            = module.vpc.vpc_id
  cidr_block_subnet = var.cidr_block_subnet
  name_vpc          = var.name_vpc
  env_vpc           = var.env_vpc
  name_subnet       = var.name_subnet
  env_subnet        = var.env_subnet
}

module "ec2" {

  source = "../modules/ec2"

  ami_id            = var.ami_id
  instance_type     = var.instance_type
  availability_zone = var.availability_zone
  region            = var.region
  subnet_id         = module.vpc.subnet_id
  name_ec2          = var.name_ec2
  env_ec2           = var.env_ec2


}