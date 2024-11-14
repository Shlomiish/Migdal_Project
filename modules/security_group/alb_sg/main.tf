# Security Group for ALB (allows HTTP traffic on port 80)
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow inbound HTTP traffic to the ALB"
  vpc_id      = var.vpc_id

  # Inbound rules (allow HTTP traffic from anywhere)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allows traffic from anywhere
  }

  # Outbound rules (allow all outbound traffic)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Allows all outbound traffic (use -1 for all protocols)
    cidr_blocks = ["0.0.0.0/0"]  # Allows traffic to anywhere
  }

  tags = {
    Name = "alb-sg"
  }
}
