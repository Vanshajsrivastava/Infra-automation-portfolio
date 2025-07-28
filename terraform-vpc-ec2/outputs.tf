output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "subnet_id" {
  description = "The ID of the Subnet"
  value       = aws_subnet.main.id
}

output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.example.id
}

output "instance_private_ip" {
  description = "The private IP address of the EC2 instance"
  value       = aws_instance.example.private_ip
}

output "instance_public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = aws_instance.example.public_ip
}
