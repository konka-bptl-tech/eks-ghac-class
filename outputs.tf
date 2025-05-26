output "vpc_id" {
  description = "The name of the VPC"
  value       = module.eks_vpc.vpc_id
}