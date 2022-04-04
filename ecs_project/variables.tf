variable "region" {
  default     = "ap-southeast-1"
  description = "Default region of our infra"
}

variable "ecs_task_execution_role_name" {
  description = "ECS task execution role name"
  default     = "myEcsTaskExecutionRole"
}

variable "cidr_block" {
  default     = "10.0.0.0/16"
  description = "Default cidr block of VPC"
}

variable "az_count" {
  default     = 2
  description = "Desired number AZs"
}

variable "to_internet" {
  default     = "0.0.0.0/0"
  description = "cidr block to route to internet"
}

variable "app_image" {
  description = "Docker image to run in the ECS cluster"
  default     = "duypk2000/flaskapi:latest"
}

variable "container_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 5000
}

variable "health_check_path" {
  default = "/"
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "1024"
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "4096"
}
variable "app_count" {
  description = "Number of docker containers to run"
  default     = 2
}
variable "container_name" {
  default = "myflaskapp"
}

variable "http_port" {
  default = 80
}
