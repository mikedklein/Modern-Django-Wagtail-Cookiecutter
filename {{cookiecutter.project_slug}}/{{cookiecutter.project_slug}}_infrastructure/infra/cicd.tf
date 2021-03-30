resource "aws_codepipeline" "{{cookiecutter.project_slug}}-pipeline" {
  name     = "{{cookiecutter.project_slug}}-pipeline"
  role_arn = aws_iam_role.{{cookiecutter.project_slug}}-cicd-role.arn

  tags = {
    Client = "PBS"
  }

  artifact_store {
    location = aws_s3_bucket.srl_storymaker_poc_cicd_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn        = aws_codestarconnections_connection.{{cookiecutter.project_slug}}.arn
        FullRepositoryId     = var.repoId
        BranchName           = var.branch
        OutputArtifactFormat = "CODEBUILD_CLONE_REF"
      }
    }
  }
  stage {
    name = "DeployDev"

    action {
      category = "Build"
      configuration = {
        "ProjectName" = "{{cookiecutter.project_slug}}-dev"
      }
      input_artifacts = [
        "source_output",
      ]
      name             = "Deploy"
      output_artifacts = []
      owner            = "AWS"
      provider         = "CodeBuild"
      region           = "{{cookiecutter.aws_region}}"
      run_order        = 1
      version          = "1"
    }
  }

  stage {
    name = "ApproveProdLaunch"

    action {
      name     = "ApproveProdLaunch"
      category = "Approval"
      owner    = "AWS"
      provider = "Manual"
      version  = "1"

      configuration = {
        CustomData = "Please confirm functionality in DEV/QA before deploying"
      }
    }
  }

  stage {
    name = "DeployProd"

    action {
      category = "Build"
      configuration = {
        "ProjectName" = "{{cookiecutter.project_slug}}-prod"
      }
      input_artifacts = [
        "source_output",
      ]
      name             = "Deploy"
      output_artifacts = []
      owner            = "AWS"
      provider         = "CodeBuild"
      region           = "{{cookiecutter.aws_region}}"
      run_order        = 1
      version          = "1"
    }
  }

}


resource "aws_codestarconnections_connection" "{{cookiecutter.project_slug}}" {
  name          = "{{cookiecutter.project_slug}}"
  provider_type = "GitHub"
  tags = {
    Client = "PBS"
  }
}

resource "aws_s3_bucket" "srl_storymaker_poc_cicd_bucket" {
  bucket = "{{cookiecutter.project_slug}}-cicd-bucket"
  acl    = "private"
  tags = {
    Client = "PBS"
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

}

resource "aws_s3_bucket_public_access_block" "s3Public-cicd" {
  bucket                  = aws_s3_bucket.srl_storymaker_poc_cicd_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}


resource "aws_codebuild_project" "srl-storyamker-poc-dev" {
  badge_enabled  = false
  build_timeout  = 60
  name           = "{{cookiecutter.project_slug}}-dev"
  queued_timeout = 480
  service_role   = aws_iam_role.codebuild-{{cookiecutter.project_slug}}-cicd-service-role.arn
  tags = {
    Client = "PBS"
  }

  artifacts {
    encryption_disabled    = false
    name                   = "{{cookiecutter.project_slug}}-dev"
    override_artifact_name = false
    packaging              = "NONE"
    type                   = "CODEPIPELINE"
  }

  cache {
    modes = []
    type  = "NO_CACHE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = var.buildImage
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
    type                        = "LINUX_CONTAINER"
  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }

    s3_logs {
      encryption_disabled = false
      status              = "DISABLED"
    }
  }

  source {
    git_clone_depth     = 0
    insecure_ssl        = false
    report_build_status = false
    type                = "CODEPIPELINE"
    buildspec           = "cicd/buildspec_dev.yml"
    location            = var.repoUrl
  }

}

resource "aws_codebuild_project" "srl-storyamker-poc-prod" {
  badge_enabled  = false
  build_timeout  = 60
  name           = "{{cookiecutter.project_slug}}-prod"
  queued_timeout = 480
  service_role   = aws_iam_role.codebuild-{{cookiecutter.project_slug}}-cicd-service-role.arn
  tags = {
    Client = "PBS"
  }

  artifacts {
    encryption_disabled    = false
    name                   = "{{cookiecutter.project_slug}}-prod"
    override_artifact_name = false
    packaging              = "NONE"
    type                   = "CODEPIPELINE"
  }

  cache {
    modes = []
    type  = "NO_CACHE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = var.buildImage
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
    type                        = "LINUX_CONTAINER"
  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }

    s3_logs {
      encryption_disabled = false
      status              = "DISABLED"
    }
  }

  source {
    git_clone_depth     = 0
    insecure_ssl        = false
    report_build_status = false
    type                = "CODEPIPELINE"
    buildspec           = "cicd/buildspec_prod.yml"
    location            = var.repoUrl
  }

}

resource "aws_iam_role_policy" "CodeBuildBasePolicy-{{cookiecutter.project_slug}}-zappa-{{cookiecutter.aws_region}}" {
  name = "CodeBuildBasePolicy-{{cookiecutter.project_slug}}-zappa-{{cookiecutter.aws_region}}"
  role = aws_iam_role.codebuild-{{cookiecutter.project_slug}}-cicd-service-role.id

  # TODO: Remove the wildcard here
  policy = data.template_file.codebuild_zappa_policy.rendered
}

resource "aws_iam_role" "codebuild-{{cookiecutter.project_slug}}-cicd-service-role" {
  name = "codebuild-{{cookiecutter.project_slug}}-cicd-service-role"
  tags = {
    Client = "PBS"
  }
  assume_role_policy = data.template_file.codebuild_assume_role.rendered
}

resource "aws_iam_role_policy" "CodeBuildBasePolicy-{{cookiecutter.project_slug}}-cicd-{{cookiecutter.aws_region}}" {
  name = "CodeBuildBasePolicy-{{cookiecutter.project_slug}}-cicd-{{cookiecutter.aws_region}}"
  role = aws_iam_role.codebuild-{{cookiecutter.project_slug}}-cicd-service-role.id

  # TODO: Remove the wildcard here
  policy = data.template_file.codebuild_base_policy.rendered
}

resource "aws_iam_role" "{{cookiecutter.project_slug}}-cicd-role" {
  name = "{{cookiecutter.project_slug}}-cicd-role"
  tags = {
    Client = "PBS"
  }
  assume_role_policy = data.template_file.codepipeline_assume_role.rendered
}

resource "aws_iam_role_policy" "{{cookiecutter.project_slug}}-cicd-role-policy" {
  name   = "{{cookiecutter.project_slug}}-cicd-role-policy"
  role   = aws_iam_role.{{cookiecutter.project_slug}}-cicd-role.id
  policy = data.template_file.codepipeline_base_policy.rendered
}