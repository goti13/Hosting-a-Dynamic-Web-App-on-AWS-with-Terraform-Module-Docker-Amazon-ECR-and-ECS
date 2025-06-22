output "vpc_id" {
  value = aws_vpc.Gerald_test_vpc.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "security_group_id" {
  value = aws_security_group.ecs_sg.id
}
