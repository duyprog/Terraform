resource "aws_lb" "alb" {
  name               = "application-load-balancer"
  internal           = false # facing to internet
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg_lb.id]
  subnets            = aws_subnet.public_subnet.*.id
}

resource "aws_lb_target_group" "alb_target_group" {
  name        = "alb-target-group"
  port        = 5000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.product_vpc.id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = var.health_check_path
    unhealthy_threshold = "5"
  }
}

resource "aws_lb_listener" "frontend" {
  load_balancer_arn = aws_lb.alb.id
  port              = var.http_port
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.alb_target_group.arn
    type             = "forward"
  }
  depends_on = [
    aws_lb_target_group.alb_target_group
  ]
}