resource "aws_codepipeline" "flask_app_pipeline" {
  name     = "flask-app-pipeline"
  role_arn = aws_iam_role.apps_codepipeline_role.arn
  tags = {
    Enviroment = var.env
  }

  artifact_store {
    location = var.artifacts_bucket_name
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      category = "Source"
      configuration = {
        "BranchName"     = var.flask_api_project_repository_branch
        "RepositoryName" = var.flask_project_repository_name
      }
      input_artifacts = []
      name = "Source"
    }
  }
}