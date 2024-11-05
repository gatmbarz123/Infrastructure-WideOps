output "vpc_name" {
  value = module.vpc.network_name
  description = "The name of the VPC"
}

output "subnet_name" {
  value = module.vpc.subnets["${var.region}/private"].name
}
output "network_self_link"{
  value = module.vpc.network_self_link
}