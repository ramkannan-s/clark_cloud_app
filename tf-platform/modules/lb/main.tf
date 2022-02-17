resource "aws_alb" "alb" {
  name            = "web-instance-alb-${var.environment}"
  subnets         = var.alb_subnets
  security_groups = var.alb_security_grps
  internal        = "false"
  idle_timeout    = var.idle_timeout
  tags = {
    Name = "web-instance-alb-${var.environment}"
  }
}

resource "aws_alb_listener" "alb_listener" {
  load_balancer_arn = aws_alb.alb.arn
  port              = var.alb_listener_port
  protocol          = var.alb_listener_protocol

  default_action {
    target_group_arn = aws_alb_target_group.alb_target_group.arn
    type             = "forward"
  }
}

resource "aws_alb_listener_rule" "listener_rule" {
  depends_on   = [aws_alb_target_group.alb_target_group]
  listener_arn = aws_alb_listener.alb_listener.arn
  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.alb_target_group.id
  }
  condition {
    path_pattern {
      values = var.alb_path
    }
  }
}

resource "aws_alb_target_group" "alb_target_group" {
  name     = "web-instance-tg-${var.environment}"
  port     = var.svc_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  tags = {
    name = "web-instance-tg-${var.environment}"
  }
  stickiness {
    type            = "lb_cookie"
    cookie_duration = 1800
    enabled         = var.target_group_sticky
  }
  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 10
    timeout             = 5
    interval            = 10
    path                = var.target_group_path
    port                = var.target_group_port
  }
}
