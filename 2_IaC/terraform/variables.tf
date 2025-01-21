variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  default     = ["10.0.2.0/24", "10.0.3.0/24"]
}

variable "instance_ami" {
  description = "AMI for EC2 instances"
  default     = "ami-12345678"
}

variable "instance_type" {
  description = "Instance type for EC2 instances"
  default     = "t2.micro"
}

variable "db_username" {
  description = "Database username"
  default     = "admin"
}

variable "db_password" {
  description = "Database password"
}

variable "admin_cidr" {
  description = "CIDR block for SSH access to the Bastion host"
  default     = "0.0.0.0/0"
}
