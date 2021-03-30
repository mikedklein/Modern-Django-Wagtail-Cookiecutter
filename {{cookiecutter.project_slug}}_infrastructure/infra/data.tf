data "aws_canonical_user_id" "current_user" {}

data "template_file" "codebuild_zappa_policy" {
  template = file("${path.module}/templates/codebuild_zappa_policy.json.tpl")
}

data "template_file" "codebuild_assume_role" {
  template = file("${path.module}/templates/codebuild_assume_role.json.tpl")
}

data "template_file" "codebuild_base_policy" {
  template = file("${path.module}/templates/codebuild_base_policy.json.tpl")

  vars = {
    s3_bucket           = "${aws_s3_bucket.srl_storymaker_poc_cicd_bucket.arn}"
    codestar_connection = "${aws_codestarconnections_connection.{{cookiecutter.project_slug}}.arn}"
  }
}

data "template_file" "codepipeline_assume_role" {
  template = file("${path.module}/templates/codepipeline_assume_role.json.tpl")
}

data "template_file" "codepipeline_base_policy" {
  template = file("${path.module}/templates/codepipeline_base_policy.json.tpl")

  vars = {
    s3_bucket           = "${aws_s3_bucket.srl_storymaker_poc_cicd_bucket.arn}"
    codestar_connection = "${aws_codestarconnections_connection.{{cookiecutter.project_slug}}.arn}"
  }
}

data "template_file" "static_asset_bucket_policy_dev" {
  template = file("${path.module}/templates/static_asset_bucket_policy_dev.json.tpl")

  vars = {
    s3_bucket = "${aws_s3_bucket.{{cookiecutter.project_slug}}-static-asset-bucket.arn}"
    oai_arn   = "${aws_cloudfront_origin_access_identity.origin_access_identity_static_dev.iam_arn}"
  }
}

data "template_file" "static_asset_bucket_policy_prd" {
  template = file("${path.module}/templates/static_asset_bucket_policy_prod.json.tpl")

  vars = {
    s3_bucket = "${aws_s3_bucket.{{cookiecutter.project_slug}}-static-asset-bucket-prd.arn}"
    oai_arn   = "${aws_cloudfront_origin_access_identity.origin_access_identity_static_prd.iam_arn}"
  }
}

data "template_file" "media_bucket_policy_prd" {
  template = file("${path.module}/templates/media_bucket_policy_prod.json.tpl")

  vars = {
    s3_bucket = "${aws_s3_bucket.{{cookiecutter.project_slug}}-media-bucket-prd.arn}"
    oai_arn   = "${aws_cloudfront_origin_access_identity.origin_access_identity_media_prd.iam_arn}"
  }
}