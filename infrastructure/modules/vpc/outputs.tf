output "vpc_id" {
  description = "ID da VPC"
  value       = aws_vpc.main.id
}

output "public_subnets" {
  description = "IDs das subnets públicas"
  value       = aws_subnet.public[*].id
}

output "private_subnets" {
  description = "IDs das subnets privadas"
  value       = aws_subnet.private[*].id
}

output "alb_security_group_id" {
  description = "ID do security group do ALB"
  value       = aws_security_group.alb.id
}

output "ecs_security_group_id" {
  description = "ID do security group do ECS"
  value       = aws_security_group.ecs.id
}
