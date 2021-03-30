terraform {
  required_version = ">= 0.14.7"
  backend "s3" {
    bucket  = "{{cookiecutter.project_slug}}-remote-state"
    key     = "tfstate/"
    region  = "{{cookiecutter.aws_region}}"
    profile = "{{cookiecutter.aws_profile}}"
  }
}

provider "aws" {
  alias   = "aws"
  version = ">= 3.31.0"
  region  = "{{cookiecutter.aws_region}}"
  aws = {
    region = "{{cookiecutter.aws_region}}"
  }
}
