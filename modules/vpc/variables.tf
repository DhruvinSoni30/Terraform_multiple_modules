# CIDR Block for VPC
variable "cidr_block" {}

# VPC ID
variable "vpc_id" {}

# Subnet CIDR
variable "cidr_block_subnet" {}

# Tags for VPC
variable "name_vpc" {
  type = string
}

variable "env_vpc" {
  type = string
}

# Tags for Subnet
variable "name_subnet" {
  type = string
}

variable "env_subnet" {
  type = string
}