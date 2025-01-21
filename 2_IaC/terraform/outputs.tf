output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_id" {
  value = module.vpc.public_subnet_id
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "bastion_public_ip" {
  value = module.bastion.public_ip
}

output "web_server_elb_dns" {
  value = module.web_server.elb_dns
}
