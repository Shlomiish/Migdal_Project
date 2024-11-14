# Create the ALB (Application Load Balancer) resource
resource "aws_lb" "jenkins_alb" {
  name               = "jenkins-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnet_ids
  enable_deletion_protection = false

  tags = {
    Name = "jenkins-alb"
  }
}

# Create Target Group for Jenkins (Listening on port 8080)
resource "aws_lb_target_group" "jenkins" {
  name        = "jenkins-target-group"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
}


# Attach Jenkins server to the target group
resource "aws_lb_target_group_attachment" "jenkins_attachment" {
  target_group_arn = aws_lb_target_group.jenkins.arn
  target_id        = var.jenkins_server_id
  port             = 8080
}

# Create the ALB Listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.jenkins_alb.arn
  port              = "80"
  protocol          = "HTTP"

  #forward to Jenkins target group
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.jenkins.arn  
  }
}