variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "key_pair" {
  description = "The key pair to connect from SSH"
  type = string
}


variable "private_subnet_1_id" {
  description = "private ip 1"
  type = string
}


variable "private_subnet_2_id" {
  description = "private ip 2"
  type = string
}


variable "public_subnet_1_id" {
  description = "public ip 1"
  type = string
}


variable "ami_list" {
  description = "List of ec2 images"
  type        = map(string)
}
 

variable "bastion_sg_id" {
  description = "The bastion security group id"
  type = string
}

variable "instance_type" {
  description = "The instance type"
  type = list(string)
}

variable "jenkins_sg_id" {
  description = "The id of the jenkins sg"
  type = string
}

variable "agent_private_sg_id" {
  description = "The id of the agent sg"
  type = string
}

variable "gitlab_sg_id" {
  description = "The id of the gitlab sg"
  type = string
}