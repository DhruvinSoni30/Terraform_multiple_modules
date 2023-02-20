# AWS VPC
resource "aws_vpc" "demo_vpc" {
 cidr_block           = var.cidr_block
 instance_tenancy     = var.tenancy
 enable_dns_hostnames = true

 tags = {
   "Name" = "${var.name}-vpc"
 }
}

# Internet Gateway
resource "aws_internet_gateway" "demo_gateway" {
 vpc_id = aws_vpc.demo_vpc.id

 tags = {
   "Name" = "${var.name}-igw"
 }
}

# AZ
data "aws_availability_zones" "az" {}

# AWS Subnet
resource "aws_subnet" "demo_subnet" {
 vpc_id                  = aws_vpc.demo_vpc.id
 cidr_block              = var.cidr_block_subnet
 availability_zone       = data.aws_availability_zones.az.names[0]
 map_public_ip_on_launch = true

 tags = {
   "Name" = "${var.name}-subnet"
 }
}

# AWS Route Table
resource "aws_route_table" "demo_route_table" {
 vpc_id = aws_vpc.demo_vpc.id

 route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.demo_gateway.id
 }

 tags = {
   "Name" = "${var.name}-route"
 }
}

# Associate public subnet to route table
resource "aws_route_table_association" "demo_association" {
 subnet_id      = aws_subnet.demo_subnet.id
 route_table_id = aws_route_table.demo_route_table.id
}