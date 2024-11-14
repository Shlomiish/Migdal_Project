# modules/security_group/variables.tf
variable "vpc_id" {
  description = "The VPC ID where the security groups will be created"
  type        = string
}

variable "local_ip" {
  description = "My local IP address to allow SSH access"
  type        = string
}

variable "bastion_private_ip" {
  description = "The bastion private ip"
  type        = string
}

variable "jenkins_private_ip" {
  description = "The jenkins private ip"
  type        = string
}

variable "agent_private_ip" {
  description = "The agent private ip"
  type        = string
}