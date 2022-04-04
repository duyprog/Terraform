resource "aws_security_group" "sg_lb" {
  name        = "myapp-load-balancer-sg"
  description = "Control access to the ALB"
  vpc_id      = aws_vpc.product_vpc.id


  ingress {
    protocol    = "TCP"
    from_port   = var.http_port
    to_port     = var.http_port
    cidr_blocks = ["${var.to_internet}"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["${var.to_internet}"]
  }
}

resource "aws_security_group" "ecs_task" {
  name        = "ecs-task-security-group"
  vpc_id      = aws_vpc.product_vpc.id
  description = "Allow inbound access from the ALB"
  ingress {
    protocol        = "TCP"
    from_port       = var.container_port
    to_port         = var.container_port
    security_groups = ["${aws_security_group.sg_lb.id}"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["${var.to_internet}"]
  }
}