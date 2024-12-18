
variable "vpc_id" {
  type        = string
  description = "The ID of the VPC."
}

Variable for subnet CIDR block
variable "cidr_block" {
  type        = string
  description = "CIDR block for the subnet."
}

Variable for availability zone
variable "availability_zone" {
  type        = string
  description = "The availability zone for the subnet."
}

Variable for public IP on launch
variable "map_public_ip_on_launch" {
  type        = bool
  description = "Whether instances in the subnet receive a public IP on launch."
  default     = true
}

Variable for subnet name
variable "subnet_name" {
  type        = string
  description = "The name of the subnet."
}
```
