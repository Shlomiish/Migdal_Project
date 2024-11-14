variable "vpc_id" {
  type = string
}

variable "gitlab_server_id" {
  type = string
}


variable "public_subnet_ids" {
  description = "The CIDR blocks for the public subnets"
  type        = list(string)
}


variable "alb_sg_id" {
  type = string
}