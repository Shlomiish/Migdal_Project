# Create the ALB (Application Load Balancer) resource
resource "aws_lb" "gitlab_alb" {
  name               = "gitlab-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnet_ids
  enable_deletion_protection = false

  tags = {
    Name = "gitlab-alb"
  }
}

# Create Target Group for Gitlab (Listening on port 80)
resource "aws_lb_target_group" "gitlab_alb" {
  name        = "gitlab-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
}

# Attach Gitlab server to the target group
resource "aws_lb_target_group_attachment" "gitlab_attachment" {
  target_group_arn = aws_lb_target_group.gitlab_alb.arn
  target_id        = var.gitlab_server_id
  port             = 80
}

# Create the ALB Listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.gitlab_alb.arn
  port              = "80"
  protocol          = "HTTP"

  #forward to GitLab target group
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.gitlab_alb.arn  
  }
}
