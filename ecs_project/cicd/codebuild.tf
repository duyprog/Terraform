resource "aws_codebuild_project" "flaskAppBuild" {
  name           = "Flask App Build"
  description    = "CodeBuild Project for Flask API ECS Cluster"
  badge_enabled  = false
  build_timeout  = 60  # Đơn vị là phút, được dùng để xác định thời gian mà CodeBuild đợi cho đến khi time out bất kì build liên quan nào không được đánh dấu là hoàn thành
  queued_timeout = 480 # Thời gian mà build được phép ở trong hàng đợi 
  service_role   = aws_iam_role.containerAppBuildProjectRole.arn

  tags = {
    Enviroment = var.env
  }

  artifacts {
    encryption_disabled = false  # Có disable encrypt cái output artifacts hay không, nếu type sẽ là NO_ARTIFACT thì giá trị này sẽ bị ignore
    packaging           = "NONE" # Type output của artifacts lưu vào S3, NONE hoặc ZIP
    type                = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL_1_SMALL"
    image                       = "aws/codebuild/standard:5.0" # Image để build project
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true # Bật docker daemon bên trong docker container 
    type                        = "LINUX_CONTAINER"
  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLE"
    }

    s3_logs {
      encryption_disabled = false
      status              = "DISABLE"
    }
  }

  source {
    git_clone_depth     = 0
    insecure_ssl        = false
    report_build_status = false
    type                = "CODEPIPELINE"
  }
}