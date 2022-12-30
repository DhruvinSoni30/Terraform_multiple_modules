# How to work with multiple terraform modules?

### What is Terraform?

Terraform is a free and open-source infrastructure as code (IAC) that can help to automate the deployment, configuration, and management of the remote servers. Terraform can manage both existing service providers and custom in-house solutions.

![1](https://github.com/DhruvinSoni30/Terraform_Multiple_Environments/blob/main/images/terraform.jpeg)

### Prerequisites:

* A server that has Terraform installed in it & AWS CLI also!
* Basic understanding of Terraform 
* Basic understanding of AWS
* AWS Access Key & Secret Key

### What are terraform modules?

A Terraform module allows you to create logical abstraction on the top of some resource set. In other words, a module allows you to group resources together and reuse this group later, possibly many times. Terraform module allow us to use the concept of DRY (Don't Repete Yourself). With the use of terraform modules you can write the code for various resources once and reuse them in different environment as per your need!

![2](https://github.com/DhruvinSoni30/Terraform_Multiple_Environments/blob/main/images/module.png)

You can read more details of terraform modules from [here](https://itoutposts.com/blog/terraform-modules-overview/)

In this tutorial we will take a look at how to use modules and maintain different infrastructure for different environment!

### Step 1: 

* We need to create the moduel for VPC so that we can use it for different environment later!
* Create a folder called `modules` and `vpc` inside `modules` folder 

  ```
  VW3N7VQKQX:Terraform_multiple_modules dhruvins$ cd modules/
  VW3N7VQKQX:modules dhruvins$ ls -la
  total 0
  drwxr-xr-x  4 dhruvins  staff  128 Dec 29 02:52 .
  drwxr-xr-x  9 dhruvins  staff  288 Dec 29 17:41 ..
  drwxr-xr-x  5 dhruvins  staff  160 Dec 29 02:11 vpc
  VW3N7VQKQX:modules dhruvins$ 
  ```
  
* Create `main.tf` file and add below code in it 
  
   ```
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
    vpc_id = var.vpc_id

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
  ```

* Create `variables.tf` file and add below code in it 

  ```
  # CIDR Block for VPC
  variable "cidr_block" {}

  # Instance Tenancy 
  variable "tenancy" {}

  # Subnet CIDR
  variable "cidr_block_subnet" {}

  # Tags
  variable "name" {}
  ```

* Create `outputs.tf` file and add below code in it

  ```
  # Getting VPC ID
  output "vpc_id" {
    value = aws_vpc.demo_vpc.id 
  }

  # Getting Subnet ID
  output "subnet_id" {
    value = aws_subnet.demo_subnet.id
  }
  ```

  ```
  VW3N7VQKQX:vpc dhruvins$ ls -la
  total 24
  drwxr-xr-x  5 dhruvins  staff   160 Dec 29 02:11 .
  drwxr-xr-x  4 dhruvins  staff   128 Dec 29 02:52 ..
  -rw-r--r--  1 dhruvins  staff  1136 Dec 29 19:55 main.tf
  -rw-r--r--  1 dhruvins  staff   147 Dec 29 02:49 outputs.tf
  -rw-r--r--  1 dhruvins  staff   163 Dec 30 19:23 variables.tf
  VW3N7VQKQX:vpc dhruvins$ 
  ```

* Now out structure for VPC module is ready, we are not using any value for the variables and so that we can different value for different environments later!

### Step 2:

* We need to create the moduel for EC2 instance and so that we can use it for different environment later!
* Create a folder called `ec2` inside `modules` folder 

* Create `main.tf` file and add below code in it 

  ```
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
  ```

* Create `variables.tf` file and add below code in it 

  ```
  # Region
  variable "region" {}

  # AMI ID
  variable "ami_id" {}

  # Instance Type
  variable "instance_type" {}

  # Subnet ID
  variable "subnet_id" {}

  # Tags 
  variable "name" {}
  ```

* Create `outputs.tf` file and add below code in it 

  ```
  # Getting Public IP of EC2 instance
  output "public_IP" {
    value = aws_instance.demo_instance.public_ip
  }
  ```

  ```
  VW3N7VQKQX:ec2 dhruvins$ ls -la
  total 24
  drwxr-xr-x  5 dhruvins  staff  160 Dec 11 01:56 .
  drwxr-xr-x@ 3 dhruvins  staff   96 Dec 11 21:55 ..
  -rw-r--r--  1 dhruvins  staff  223 Dec 11 01:39 main.tf
  -rw-r--r--  1 dhruvins  staff   70 Dec 11 01:37 output.tf
  -rw-r--r--  1 dhruvins  staff  266 Dec 11 01:38 variables.tf
  VW3N7VQKQX:ec2 dhruvins$ 
  ```

* Now out structure for EC2 module is ready, we are not using any value for the variables and so that we can different value for different environments later


### Step 3:

* Create folders like `stg`, `lve` & `dev` for different environments like below

  ```
  VW3N7VQKQX:Terraform_multiple_modules dhruvins$ ls -la
  total 16
  drwxr-xr-x    9 dhruvins  staff   288 Dec 29 17:41 .
  drwx------@ 182 dhruvins  staff  5824 Dec 29 02:15 ..
  drwxr-xr-x   14 dhruvins  staff   448 Dec 29 17:42 .git
  -rw-r--r--    1 dhruvins  staff   650 Dec 29 17:41 .gitignore
  -rw-r--r--    1 dhruvins  staff    28 Dec 29 02:07 README.md
  drwxr-xr-x    8 dhruvins  staff   256 Dec 30 19:14 dev
  drwxr-xr-x    4 dhruvins  staff   128 Dec 29 02:52 modules
  drwxr-xr-x    8 dhruvins  staff   256 Dec 30 19:10 prod
  drwxr-xr-x    8 dhruvins  staff   256 Dec 29 19:34 stg
  VW3N7VQKQX:Terraform_multiple_modules dhruvins$ 
  ```

* First, we will define the code for the `stg` environment 
* Create `main.tf` file and add below code in it 

  ```
  module "vpc" {
    source = "../modules/vpc"

    cidr_block        = var.cidr_block
    vpc_id            = module.vpc.vpc_id
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
  ```


* In the above code we are calling the ec2 & vpc module and using the mandatory variables 

* Create `provider.tf` file and add below code in it 

  ```
  provider "aws" {
    region = var.region
    profile = "default"
  }

  terraform {
    backend "s3" {
      bucket = "tf-state-dhsoni"
      region = "us-west-2"
      key    = "stg/terraform.tfstate"
      profile = "default"
    }

* We are using S3 bucket for storing the state file in it so, that we do not need to maintain it locally and for that I have already created the bucket called `tf-state-dhsoni` on AWS
* The above code will create `stg` folder inside the `tf-state-dhsoni` bucket and store the state file for `stg` environment 

* Create `variables.tf` file and add below code in it 

  ```
  # CIDR Block for VPC
  variable "cidr_block" {}

  # Subnet CIDR
  variable "cidr_block_subnet" {}

  # Instance Tenancy 
  variable "tenancy" {}

  # Tags
  variable "name" {}

  # Region
  variable "region" {}

  # AMI ID
  variable "ami_id" {}

  # Instance Type
  variable "instance_type" {}
  ```

* Create `terraform.tfvars` file and add below code in it 

  ```
  cidr_block        = "10.0.0.0/16"
  cidr_block_subnet = "10.0.1.0/24"
  name              = "stg"
  ami_id            = "ami-0a606d8395a538502"
  instance_type     = "t2.micro"
  region            = "us-east-2"
  tenancy           = "default"
  ```

* The above values for all the variables for `stg` environment 

### Step 4:

* Now, we will define the code for the `prod` environment 
* Create `main.tf` file and add below code in it 

  ```
  module "vpc" {
    source = "../modules/vpc"

    cidr_block        = var.cidr_block
    vpc_id            = module.vpc.vpc_id
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
  ```

* In the above code we are calling the ec2 & vpc module and using the mandatory variables 

* Create `provider.tf` file and add below code in it 

  ```
  provider "aws" {
    region = var.region
    profile = "default"
  }

  terraform {
    backend "s3" {
      bucket = "tf-state-dhsoni"
      region = "us-west-2"
      key    = "prod/terraform.tfstate"
      profile = "default"
    }

* The above code will create `prod` folder inside the `tf-state-dhsoni` bucket and store the state file for `prod` environment 

* Create `variables.tf` file and add below code in it 

  ```
  # CIDR Block for VPC
  variable "cidr_block" {}

  # Subnet CIDR
  variable "cidr_block_subnet" {}

  # Instance Tenancy 
  variable "tenancy" {}

  # Tags
  variable "name" {}

  # Region
  variable "region" {}

  # AMI ID
  variable "ami_id" {}

  # Instance Type
  variable "instance_type" {}
  ```

* Create `terraform.tfvars` file and add below code in it 

  ```
  cidr_block        = "30.0.0.0/16"
  cidr_block_subnet = "30.0.1.0/24"
  name              = "prod"
  ami_id            = "ami-0a606d8395a538502"
  instance_type     = "t2.micro"
  region            = "us-east-2"
  tenancy           = "default"
  ```

* The above values for all the variables for `prod` environment 

### Step 5:

* Now, we will define the code for the `dev` environment 
* Create `main.tf` file and add below code in it 

  ```
  module "vpc" {
    source = "../modules/vpc"

    cidr_block        = var.cidr_block
    vpc_id            = module.vpc.vpc_id
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
  ```

* In the above code we are calling the ec2 & vpc module and using the mandatory variables 

* Create `provider.tf` file and add below code in it 

  ```
  provider "aws" {
    region = var.region
    profile = "default"
  }

  terraform {
    backend "s3" {
      bucket = "tf-state-dhsoni"
      region = "us-west-2"
      key    = "dev/terraform.tfstate"
      profile = "default"
    }

* The above code will create `dev` folder inside the `tf-state-dhsoni` bucket and store the state file for `dev` environment 

* Create `variables.tf` file and add below code in it 

  ```
  # CIDR Block for VPC
  variable "cidr_block" {}

  # Subnet CIDR
  variable "cidr_block_subnet" {}

  # Instance Tenancy 
  variable "tenancy" {}

  # Tags
  variable "name" {}

  # Region
  variable "region" {}

  # AMI ID
  variable "ami_id" {}

  # Instance Type
  variable "instance_type" {}
  ```

* Create `terraform.tfvars` file and add below code in it 

  ```
  cidr_block        = "20.0.0.0/16"
  cidr_block_subnet = "20.0.1.0/24"
  name              = "dev"
  ami_id            = "ami-0a606d8395a538502"
  instance_type     = "t2.micro"
  region            = "us-east-2"
  tenancy           = "default"
  ```

* The above values for all the variables for `dev` environment 

* Now, our entire setup is ready for all the different environments!

Run below command one by one from each folder i.e. `stg`, `dev` & `prod` and you will see 3 different instances & for that 3 different VPCs and state file for each environment!

  ```
  terraform init
  terraform plan
  terraform apply
  ```
  
  





















