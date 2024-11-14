# Security group for Gitlab server
resource "aws_security_group" "jenkins_sg" {
  vpc_id = var.vpc_id  

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.bastion_private_ip}/32"]  
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    security_groups = [var.alb_sg_id]  # Allow traffic from ALB security group
  }

  # Ingress rule: Allow HTTP traffic from ALB's security group
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [var.alb_sg_id]  
  }

  egress {
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1"
  }

  tags = {
    Name = "Jenkins_sg"
  }
}



# Security group for Gitlab server
resource "aws_security_group" "gitlab_sg" {
  vpc_id = var.vpc_id  

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.bastion_private_ip}/32"]  
  }



  # Ingress rule: Allow HTTP traffic from ALB's security group
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [var.alb_sg_id]  
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.jenkins_private_ip}/32"]  
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.agent_private_ip}/32"]  
  }

  egress {
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1"
  }

  tags = {
    Name = "Gitlab_sg"
  }
}


resource "aws_security_group" "agent_sg" {
  vpc_id = var.vpc_id  

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.bastion_private_ip}/32"]  
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.jenkins_private_ip}/32"]  
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1"
  }

  tags = {
    Name = "Agent_sg"
  }
}




