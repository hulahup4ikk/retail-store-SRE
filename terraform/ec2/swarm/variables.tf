variable "environment_name" {
  description = "Name prefix for created resources"
  type        = string
  default     = "retail-store-sre"
}

variable "instance_type" {
  description = "EC2 instance type for swarm nodes"
  type        = string
  default     = "t3.small"
}

variable "key_name" {
  description = "Existing EC2 key pair name"
  type        = string
}

variable "allowed_cidr" {
  description = "CIDR allowed to access SSH and published services"
  type        = string
  default     = "0.0.0.0/0"
}
