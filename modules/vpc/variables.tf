variable "aws_region" {
  type        = string
  description = "The AWS region to deploy into"
  default     = "eu-central-1"
}

variable "environment" {
  type        = string
  description = "Deployment environment name (e.g., dev, prod)"
}

variable "vpc_cidr" {
  type        = string
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "List of CIDR blocks for public subnets"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "List of CIDR blocks for private subnets"
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "availability_zones" {
  type        = list(string)
  description = "List of Availability Zones to use"
  default     = ["eu-central-1a", "eu-central-1b"]
}