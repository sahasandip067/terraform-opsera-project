variable "region" {
  default = "us-east-2"
}

variable "environment" {
  description = "Environment name (dev or prod)"
  default     = "dev"
}

variable "allowed_cidr" {
  description = "CIDR block for SSH access"
  default     = "203.0.113.0/24"
}
