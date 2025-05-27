variable "environment" {
  description = "The environment for the VPC (e.g., dev, staging, prod)"
  type        = string
}
variable "project_name" {
  description = "The name of the project for which the VPC is being created"
  type        = string
}
variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}
variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "public_subnet_cidr_block" {
  description = "List of public subnet CIDR blocks"
  type        = list(string)
}
variable "azs" {
  description = "List of availability zones"
  type        = list(string)
}