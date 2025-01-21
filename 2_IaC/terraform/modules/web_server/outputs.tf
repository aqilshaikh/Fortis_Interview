output "elb_dns" {
  value = aws_elb.main.dns_name
}
