output "vpc_id" {
  description = "ID of the capstone VPC."
  value       = aws_vpc.capstone.id
}

output "ec2_instance_id" {
  description = "ID of the EC2 instance."
  value       = module.ec2_instance.id
}

output "ec2_public_ip" {
  description = "Public IPv4 address of the EC2 instance."
  value       = module.ec2_instance.public_ip
}

output "application_bucket_name" {
  description = "Name of the private, versioned application S3 bucket."
  value       = aws_s3_bucket.application.id
}

output "web_url" {
  description = "HTTP demo URL."
  value       = "http://${module.ec2_instance.public_ip}"
}
