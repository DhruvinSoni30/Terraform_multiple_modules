resource "aws_instance" "demo_instance" {

ami               = var.ami_id
instance_type     = var.instance_type
availability_zone = data.aws_availability_zones.az.names[0]
subnet_id         = var.subnet_id

 tags = {
    "Name" = "${var.name}-instance"
  }
}

# AZ
data "aws_availability_zones" "az" {}
