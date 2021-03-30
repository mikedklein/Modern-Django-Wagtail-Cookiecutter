variable "aws_region" {}

### DEV VARS ###
variable "db_name_dev" {
  description = "Database name"
  type        = string
}

variable "db_username_dev" {
  description = "Database administrator username"
  type        = string
  sensitive   = true
}

variable "db_password_dev" {
  description = "Database administrator password"
  type        = string
  sensitive   = true
}

variable "cache_policy_dev" {
  description = "Dev Cloudfront Cache Policy"
  type        = string
}

variable "origin_request_policy_dev" {
  description = "Dev Cloudfront Origin Policy"
  type        = string
}

variable "kms_key_id_dev" {
  description = "Dev Database KMS Key ARN"
  type        = string
}

### PROD VARS ###
variable "db_name_prd" {
  description = "Database name"
  type        = string
}

variable "db_username_prd" {
  description = "Database administrator username"
  type        = string
  sensitive   = true
}

variable "db_password_prd" {
  description = "Database administrator password"
  type        = string
  sensitive   = true
}

variable "cache_policy_prd" {
  description = "Prod Cloudfront Cache Policy"
  type        = string
}

variable "origin_request_policy_prd" {
  description = "Prod Cloudfront Origin Policy"
  type        = string
}

variable "kms_key_id_prd" {
  description = "Prod Database KMS Key ARN"
  type        = string
}

### CICD VARS ###
variable "repoUrl" {
  description = "Github Repo URL"
  type        = string
}

variable "repoId" {
  description = "Github Repo ID"
  type        = string
}

variable "branch" {
  description = "Deployment Branch"
  type        = string
}

variable "buildImage" {
  description = "Docker image used by CodeBuild"
  type        = string
}