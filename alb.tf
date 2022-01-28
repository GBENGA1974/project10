# APPLICATION LOAD BALANCER FILE
# terraform create application load balancer

# APPLICATION LOAD BALANCER

resource "aws_lb" "project10-alb" {
  name = "project10-alb"
  internal = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.project10-vpc-security-group.id, aws_security_group.project10-db-secgrp.id]

  enable_deletion_protection = false

    subnet_mapping {
    subnet_id     = aws_subnet.project10-pubsubnet1.id
  }

  subnet_mapping {
    subnet_id     = aws_subnet.project10-pubsubnet2.id
  }

  tags = {
    name = "project10-alb"
  }
}

# TARGET GROUP

resource "aws_alb_target_group" "project10_alb_target_group" {
  name        = "project10-tg"
  target_type = "instance"
  protocol    = "HTTP"
  port        = "80"
  vpc_id      = aws_vpc.project10_vpc_cluster.id

  health_check {
    healthy_threshold   = 5
    interval            = 100
    matcher             = "200,301,302"
    path                = "/"
    timeout             = 50
    unhealthy_threshold = 2
  }
}

# LISTENER ON PORT 80 WITH REDIRECT APPLICATION

resource "aws_lb_listener" "project10-alb-listener" {
  load_balancer_arn = aws_lb.project10-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.project10_alb_target_group.arn
    type             = "forward"
  }
}

# SECURITY GROUP FOR LOAD BALANCER
resource "aws_security_group" "lb" {
    name   = "allow-all-lb"
  vpc_id = aws_vpc.project10_vpc_cluster.id
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}