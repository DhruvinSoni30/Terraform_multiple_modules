# AWS VPC
resource "aws_vpc" "demo_vpc" {
  cidr_block = var.cidr_block

  tags = {
    "Name" = var.name_vpc
    "Env"  = var.env_vpc
  }
}

# AWS Subnet
resource "aws_subnet" "demo_subnet" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.cidr_block_subnet
  map_public_ip_on_launch = true

  tags = {
    "Name" = var.name_subnet
    "Env"  = var.env_subnet
  }
}