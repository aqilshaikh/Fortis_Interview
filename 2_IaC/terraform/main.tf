provider "aws" {
  region = var.region
}

# Call VPC module
module "vpc" {
  source              = "./modules/vpc"
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidrs = var.private_subnet_cidrs
}

# Call Bastion Host module
module "bastion" {
  source          = "./modules/bastion"
  vpc_id          = module.vpc.vpc_id
  public_subnet_id = module.vpc.public_subnet_id
  admin_cidr      = var.admin_cidr
  instance_ami    = var.instance_ami
  instance_type   = var.instance_type
}

# Call Web Server module
module "web_server" {
  source             = "./modules/web_server"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  public_subnet_id   = module.vpc.public_subnet_id
  elb_security_group = module.web_server.elb_security_group_id
  instance_ami       = var.instance_ami
  instance_type      = var.instance_type
}

# Call RDS module
module "rds" {
  source             = "./modules/rds"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  rds_security_group = module.web_server.web_server_sg_id
  db_username        = var.db_username
  db_password        = var.db_password
}
