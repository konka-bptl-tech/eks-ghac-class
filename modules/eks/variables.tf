variable "environment" {
  type        = string
  description = "The environment for the EKS cluster, e.g., dev, staging, prod."
}
variable "project_name" {
  type        = string
  description = "The name of the project for the EKS cluster."
}
variable "cluster_version" {
  type        = string
  description = "The version of the EKS cluster."
}
variable "vpc_id" {
  description = "The ID of the VPC where the security group will be created."
  type        = string
}
variable "common_tags" {
  description = "Common tags to apply to all resources."
  type        = map(string)
  default     = {}
}
variable "subnet_ids_cluster" {
  description = "List of subnet IDs for the EKS cluster."
  type        = list(string)
}
variable "endpoint_private_access" {
  description = "Enable private access to the EKS API server."
  type        = bool  
}
variable "endpoint_public_access" {
  description = "Enable public access to the EKS API server."
  type        = bool  
}
variable "public_access_cidrs" {
  description = "List of CIDRs that are allowed to access the EKS API server."
  type        = list(string)
}
variable "bootstrap_cluster_creator_admin_permissions" {
  description = "Enable admin permissions for the bootstrap cluster creator."
  type        = bool
}

variable "node_groups" {}