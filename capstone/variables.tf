variable "aws_region" {
  description = "AWS region for the capstone infrastructure."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Short project name used in resource names and tags."
  type        = string
  default     = "hcltech-capstone"
}

variable "environment" {
  description = "Deployment environment."
  type        = string
  default     = "dev"
  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "environment must be dev or prod."
  }
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}

variable "my_ip_cidr" {
  description = "Your public IPv4 address in CIDR notation for SSH, e.g. 203.0.113.10/32."
  type        = string
  default     = "127.0.0.1/32"
  validation {
    condition     = can(cidrhost(var.my_ip_cidr, 0))
    error_message = "my_ip_cidr must be a valid IPv4 CIDR."
  }
}

variable "allowed_ssh_cidr" {
  description = "Restrict SSH ingress to your IP. Override at apply time; never use 0.0.0.0/0."
  type        = string
  default     = "127.0.0.1/32"
}

