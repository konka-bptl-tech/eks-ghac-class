output "vpc_id" {
    description = "The ID of the VPC"
    value       = aws_vpc.main.id
}
output "public_subnet_ids" {
    description = "List of public subnet IDs"
    value       = aws_subnet.public[*].id
}
output "private_subnet_ids" {
    description = "List of private subnet IDs"
    value       = aws_subnet.private[*].id
}
output "db_subnet_ids" {
    description = "List of db subnet IDs"
    value       = aws_subnet.db[*].id
}

output "sg_id" {
    description = "The ID of the security group"
    value       = aws_security_group.allow_all.id
}