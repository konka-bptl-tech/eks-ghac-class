output "vpc_id" {
  description = "The name of the VPC"
  value       = module.eks_vpc.vpc_id
}
output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.eks_vpc.public_subnet_ids
}