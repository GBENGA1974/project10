# ECS CLUSTER file

resource "aws_ecs_cluster" "project10_ecs_cluster" {
  name = "project10-ecs-cluster"
  capacity_providers = [aws_ecs_capacity_provider.test-project.name]
  tags = {
    "env"       = "dev"
    "createdBy" = "gbenga1974"
  }
}

resource "aws_ecs_capacity_provider" "test-project" {
  name = "test-project"
  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.ecs_asg.arn
    managed_termination_protection = "ENABLED"
    managed_scaling {
      status          = "ENABLED"
      target_capacity = 85
    }
  }
}


# task task_definition as stated in the json file

resource "aws_ecs_task_definition" "task-definition-project10" {
  family                = "web-family"
  container_definitions = file("containerdefi.json")
  network_mode          = "bridge"
  tags = {
    "env"       = "dev"
    "createdBy" = "gbenga1974"
  }
}

# ecs service

resource "aws_ecs_service" "service_project10" {
  name            = "web-service_project10"
  cluster         = aws_ecs_cluster.project10_ecs_cluster.id
  task_definition = aws_ecs_task_definition.task-definition-project10.arn
  desired_count   = 5
  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }
  load_balancer {
    target_group_arn = aws_alb_target_group.project10_alb_target_group.arn
    container_name   = "project10_app_repo"
    container_port   = 80
  }
  # Optional: Allow external changes without Terraform plan difference(for example ASG)

  lifecycle {
    ignore_changes = [desired_count]
  }
  launch_type = "EC2"
  depends_on  = [aws_lb_listener.project10-alb-listener]
}

resource "aws_cloudwatch_log_group" "log_group" {
  name = "/ecs/frontend-container"
  tags = {
    "env"       = "dev"
    "createdBy" = "gbenga1974"
  }
}