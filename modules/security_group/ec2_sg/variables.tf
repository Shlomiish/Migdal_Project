variable "vpc_id" {
  description = "The VPC id"
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

variable "alb_sg_id" {
  description = "Security group ID for the ALB"
  type        = string
}

variable "agent_private_ip" {
  description = "The agent private ip"
  type        = string
}