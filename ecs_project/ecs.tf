resource "aws_ecs_cluster" "main" {
  name = "myapp-cluster"
}

data "template_file" "myapp" {
  template = file("./templates/ecs/myapp.json.tpl")

  vars = {
    app_image      = var.app_image
    container_port = var.container_port
    fargate_cpu    = var.fargate_cpu
    fargate_memory = var.fargate_memory
    aws_region     = var.region
    container_name = var.container_name
  }

}

resource "aws_ecs_task_definition" "app" {
  family                   = "myapp-task"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = data.template_file.myapp.rendered
}

resource "aws_ecs_service" "main" {
  name            = "myapp-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_task.id]
    subnets          = aws_subnet.public_subnet.*.id
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.alb_target_group.id
    container_name   = var.container_name
    container_port   = var.container_port
  }
  depends_on = [aws_lb_listener.frontend, aws_iam_role_policy_attachment.ecs_task_execution_role]

}