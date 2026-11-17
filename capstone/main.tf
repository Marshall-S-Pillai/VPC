data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "aws_vpc" "capstone" {
  cidr_block           = "10.20.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name        = "${var.project_name}-${var.environment}-vpc"
    Environment = var.environment
  }
}

resource "aws_internet_gateway" "capstone" {
  vpc_id = aws_vpc.capstone.id
  tags   = { Name = "${var.project_name}-${var.environment}-igw" }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.capstone.id
  cidr_block              = "10.20.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "${var.aws_region}a"
  tags = { Name = "${var.project_name}-${var.environment}-public-subnet" }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.capstone.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.capstone.id
  }
  tags = { Name = "${var.project_name}-${var.environment}-public-rt" }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "web" {
  name        = "${var.project_name}-${var.environment}-web-sg"
  description = "SSH restricted to the operator IP; HTTP open for demo."
  vpc_id      = aws_vpc.capstone.id

  ingress {
    description = "SSH from operator IP only"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  ingress {
    description = "HTTP demo access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.project_name}-${var.environment}-web-sg" }
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 5.7"

  name                        = "${var.project_name}-${var.environment}-web"
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.web.id]
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    dnf update -y
    dnf install -y httpd
    systemctl enable --now httpd
    echo "HCLTech Terraform Capstone - ${var.environment}" > /var/www/html/index.html
  EOF

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_s3_bucket" "application" {
  bucket        = "${var.project_name}-${var.environment}-${random_id.bucket_suffix.hex}"
  force_destroy = false
  tags = {
    Name        = "${var.project_name}-${var.environment}-app-bucket"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_versioning" "application" {
  bucket = aws_s3_bucket.application.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "application" {
  bucket = aws_s3_bucket.application.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "application" {
  bucket                  = aws_s3_bucket.application.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
