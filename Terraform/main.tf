provider "aws" {
  region = "us-west-2"
}

module "vpc" {
  source        = "./vpc"
  vpc_cidr      = "10.0.0.0/16"
  public_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
}

module "ec2" {
  source         = "./ec2"
  my_public_key  = "/tmp/id_rsa.pub"
  instance_type  = "t2.micro"
  security_group = module.vpc.security_group
  subnets        = module.vpc.public_subnets
}

module "alb" {
  source       = "./alb"
  vpc_id       = module.vpc.aws_vpc_id
  instance1_id = module.ec2.instance1_id
  instance2_id = module.ec2.instance2_id
  subnet1      = module.vpc.subnet1
  subnet2      = module.vpc.subnet2
}
