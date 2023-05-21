variable "naming_prefix" {
  type        = string
  description = "Naming prefix for resources"
  default     = "globoweb"
}

variable "aws_region" {
  type        = string
  description = "AWS Region to use for resources"
  default     = "us-east-1"
}

variable "vpc_cidr_block" {
  type        = map(string)
  description = "Base CIDR Block for VPC"
}

variable "vpc_subnet_count" {
  type        = map(number)
  description = "Number of subnets to create"
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "Enable DNS Hostname in VPC"
  default     = true
}

variable "vpc_subnets_cidr_block" {
  type        = list(string)
  description = "CIDR Block for Subnets VPC"
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "map_public_ip_on_launch" {
  type        = bool
  description = "Map a public IP address for Subnet Instances"
  default     = true
}

variable "instance_type" {
  type        = map(string)
  description = "Type of EC2 instance"
}

variable "instance_count" {
  type        = map(number)
  description = "Number of instances to create in VPC"
}

variable "company" {
  type        = string
  description = "Company name for resource tagging"
  default     = "PPS mantics"
}

variable "project" {
  type        = string
  description = "Project name for resource tagging"
}

variable "billing_code" {
  type        = string
  description = "Billing code for resource tagging"
}