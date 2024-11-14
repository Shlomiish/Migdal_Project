variable "vpc_id" {
  description = "The VPC ID where the security group will be created"
  type        = string
}


variable "local_ip" {
  description = "my local IP address to allow SSH access"
  type        = string
}
