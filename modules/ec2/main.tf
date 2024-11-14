# Bastion Host EC2 instance (public subnet)
resource "aws_instance" "bastion_host" {
  ami               = var.ami_list["ubuntu_ami"]
  instance_type     = var.instance_type[0]
  key_name          = var.key_pair        
  subnet_id         = var.public_subnet_1_id  
  security_groups   = [var.bastion_sg_id]

  tags = {
    Name = "Bastion Host"
  }
}


# Jenkins Server EC2 instance (private subnet)
resource "aws_instance" "jenkins_server" {
  ami               = var.ami_list["jenkins_ami"]  
  instance_type     = var.instance_type[1]
  key_name          = var.key_pair  
  subnet_id         = var.private_subnet_1_id
  vpc_security_group_ids = [var.jenkins_sg_id] 

  tags = {
    Name = "Jenkins Server"
  }
}

# Agent Server EC2 instance (private subnet)
resource "aws_instance" "agent_server" {
  ami               = var.ami_list["agent_ami"]  
  instance_type     = var.instance_type[0]
  key_name          = var.key_pair  
  subnet_id         = var.private_subnet_1_id
  vpc_security_group_ids = [var.agent_private_sg_id] 

  tags = {
    Name = "Agent Server"
  }
}

# Gitlab Server EC2 instance (private subnet)
resource "aws_instance" "gitlab_server" {
  ami               = var.ami_list["gitlab_ami"]  
  instance_type     = var.instance_type[2]
  key_name          = var.key_pair  
  subnet_id         = var.private_subnet_1_id
  vpc_security_group_ids = [var.gitlab_sg_id] 

  tags = {
    Name = "Gitlab Server"
  }
}

