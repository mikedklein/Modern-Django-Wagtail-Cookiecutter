resource "aws_s3_bucket" "{{cookiecutter.project_slug}}-static-asset-bucket-prd" {
  bucket = "{{cookiecutter.project_slug}}-static-asset-bucket-prd"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  #TODO: Lock this down for prod
  cors_rule {
    allowed_headers = ["Authorization"]
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
    max_age_seconds = 3000
  }

  tags = {
    Client = "{{cookiecutter.client}}"
  }
}

resource "aws_s3_bucket" "{{cookiecutter.project_slug}}-media-bucket-prd" {
  bucket = "{{cookiecutter.project_slug}}-media-bucket-prd"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  #TODO: Lock this down for prod
  cors_rule {
    allowed_headers = ["Authorization"]
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
    max_age_seconds = 3000
  }

  tags = {
    Client = "{{cookiecutter.client}}"
  }
}

resource "aws_s3_bucket_public_access_block" "s3Public-prd" {
  bucket                  = aws_s3_bucket.{{cookiecutter.project_slug}}-static-asset-bucket-prd.id
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

resource "aws_s3_bucket_public_access_block" "s3Public-media-prd" {
  bucket                  = aws_s3_bucket.{{cookiecutter.project_slug}}-media-bucket-prd.id
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

resource "aws_rds_cluster" "storymaker-postgresql-prd" {
  enable_http_endpoint    = true
  cluster_identifier      = "storymaker-postgresql-prd"
  engine                  = "aurora-postgresql"
  engine_mode             = "serverless"
  availability_zones      = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
  database_name           = var.db_name_prd
  master_username         = var.db_username_prd
  master_password         = var.db_password_prd
  backup_retention_period = 5
  preferred_backup_window = "07:00-09:00"


  scaling_configuration {
    min_capacity = 2
    auto_pause   = false
  }

  tags = {
    Client = "{{cookiecutter.client}}"
  }

  kms_key_id        = var.kms_key_id_prd
  storage_encrypted = true
}

resource "aws_secretsmanager_secret" "{{cookiecutter.project_slug}}-secrets-prd" {
  name = "{{cookiecutter.project_slug}}-prd"
  tags = {
    "Client" = "{{cookiecutter.client}}"
  }
}

resource "aws_cloudfront_distribution" "{{cookiecutter.project_slug}}-cf-static-prd" {
  aliases          = []
  enabled          = true
  http_version     = "http2"
  is_ipv6_enabled  = true
  price_class      = "PriceClass_All"
  retain_on_delete = false
  tags = {
    "Client" = "{{cookiecutter.client}}"
  }
  wait_for_deployment = true

  default_cache_behavior {
    allowed_methods = [
      "GET",
      "HEAD"
    ]
    cache_policy_id = var.cache_policy_prd
    cached_methods = [
      "GET",
      "HEAD"
    ]
    compress                 = true
    default_ttl              = 0
    max_ttl                  = 0
    min_ttl                  = 0
    origin_request_policy_id = var.origin_request_policy_prd
    smooth_streaming         = false
    target_origin_id         = "S3-${aws_s3_bucket.{{cookiecutter.project_slug}}-static-asset-bucket-prd.id}"
    trusted_signers          = []
    viewer_protocol_policy   = "redirect-to-https"
  }

  origin {
    domain_name = aws_s3_bucket.{{cookiecutter.project_slug}}-static-asset-bucket-prd.bucket_domain_name
    origin_id   = "S3-${aws_s3_bucket.{{cookiecutter.project_slug}}-static-asset-bucket-prd.id}"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity_static_prd.cloudfront_access_identity_path
    }
  }

  restrictions {
    geo_restriction {
      locations        = []
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
    minimum_protocol_version       = "TLSv1"
  }
}

resource "aws_cloudfront_distribution" "{{cookiecutter.project_slug}}-cf-media-prd" {
  aliases          = []
  enabled          = true
  http_version     = "http2"
  is_ipv6_enabled  = true
  price_class      = "PriceClass_All"
  retain_on_delete = false
  tags = {
    "Client" = "{{cookiecutter.client}}"
  }
  wait_for_deployment = true

  default_cache_behavior {
    allowed_methods = [
      "GET",
      "HEAD",
      "DELETE",
      "OPTIONS",
      "PATCH",
      "POST",
      "PUT"
    ]
    cache_policy_id = var.cache_policy_prd
    cached_methods = [
      "GET",
      "HEAD"
    ]
    compress                 = true
    default_ttl              = 0
    max_ttl                  = 0
    min_ttl                  = 0
    origin_request_policy_id = var.origin_request_policy_prd
    smooth_streaming         = false
    target_origin_id         = "S3-${aws_s3_bucket.{{cookiecutter.project_slug}}-media-bucket-prd.id}"
    trusted_signers          = []
    viewer_protocol_policy   = "redirect-to-https"
  }

  origin {
    domain_name = aws_s3_bucket.{{cookiecutter.project_slug}}-media-bucket-prd.bucket_domain_name
    origin_id   = "S3-${aws_s3_bucket.{{cookiecutter.project_slug}}-media-bucket-prd.id}"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity_media_prd.cloudfront_access_identity_path
    }

  }

  restrictions {
    geo_restriction {
      locations        = []
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
    minimum_protocol_version       = "TLSv1"
  }
}

resource "aws_s3_bucket_policy" "static-asset-bucket-policy-prd" {
  bucket = aws_s3_bucket.{{cookiecutter.project_slug}}-static-asset-bucket-prd.id
  policy = data.template_file.static_asset_bucket_policy_prd.rendered
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity_static_prd" {
  comment = "access-identity-{{cookiecutter.project_slug}}-static-asset-bucket-prd.s3.amazonaws.com"
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity_media_prd" {
  comment = "access-identity-{{cookiecutter.project_slug}}-media-bucket-prd.s3.amazonaws.com"
}