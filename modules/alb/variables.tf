variable "public_subnet_ids" {
  type        = list(string)
}

variable "vpc_id" {
  type = string
}

variable "alb_sg_id" {
  type = string
}

variable "jenkins_server_id" {
  type = string
}

variable "gitlab_server_id" {
  type = string
}