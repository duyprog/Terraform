variable "aws_region" {
  description = "AWS region to launch servers"
  default     = "ap-southeast-1"
}

variable "env" {
  description = "Targeted Deployment enviroment"
  default     = "dev"
}

variable "flask_project_repository_name" {
  description = "Flask Project Repository name"
  default     = "flaskapi"
}

variable "flask_api_project_repository_branch" {
  description = "Flask API Project Repository to connect to"
  default     = "master"
}

variable "artifacts_bucket_name" {
  description = "S3 bucket name for storing artifacts"
  default     = "Ti nua tui tao nhe"
}

