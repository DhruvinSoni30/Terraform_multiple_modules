resource "aws_instance" "demo_instance" {

  ami               = var.ami_id
  instance_type     = var.instance_type
  availability_zone = var.availability_zone
  subnet_id         = var.subnet_id

  tags = {
    "Name" = var.name_ec2
    "Env"  = var.env_ec2
  }

}