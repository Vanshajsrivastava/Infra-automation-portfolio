terraform {
  required_version = ">= 1.6.0"

  backend "remote" {
    organization = "Vanshaj-cloud"
    workspaces {
      name = "s3-static-website"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


provider "aws" {
  region = var.region
}

# -------------------------
# S3 bucket (private)
# -------------------------
resource "aws_s3_bucket" "site" {
  bucket = var.bucket_name
  tags   = var.tags
}

# Block all public access at the bucket level
resource "aws_s3_bucket_public_access_block" "site" {
  bucket                  = aws_s3_bucket.site.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

# -------------------------
# Upload site files to S3
# -------------------------
locals {
  mime_types = {
    "html"  = "text/html"
    "htm"   = "text/html"
    "css"   = "text/css"
    "js"    = "application/javascript"
    "json"  = "application/json"
    "png"   = "image/png"
    "jpg"   = "image/jpeg"
    "jpeg"  = "image/jpeg"
    "svg"   = "image/svg+xml"
    "gif"   = "image/gif"
    "ico"   = "image/x-icon"
    "txt"   = "text/plain"
    "xml"   = "application/xml"
    "pdf"   = "application/pdf"
    "woff"  = "font/woff"
    "woff2" = "font/woff2"
  }
}

locals {
  site_files = fileset("${path.module}/site", "**")
  file_ext_map = {
    for f in local.site_files :
    f => lower(element(split(".", f), length(split(".", f)) - 1))
    if length(split(".", f)) > 1
  }
}

resource "aws_s3_object" "files" {
  for_each      = toset(local.site_files)
  bucket        = aws_s3_bucket.site.id
  key           = each.value
  source        = "${path.module}/site/${each.value}"
  etag          = filemd5("${path.module}/site/${each.value}")
  content_type  = lookup(local.mime_types, lookup(local.file_ext_map, each.value, ""), null)
  cache_control = contains(["html", "htm"], lookup(local.file_ext_map, each.value, "")) ? "no-cache" : "public, max-age=31536000, immutable"
}

# -------------------------
# CloudFront + OAC (HTTPS)
# -------------------------
resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "oac-${aws_s3_bucket.site.bucket}"
  description                       = "OAC for ${aws_s3_bucket.site.bucket}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "cdn" {
  enabled             = true
  comment             = "Static site for ${aws_s3_bucket.site.bucket}"
  default_root_object = var.index_document
  price_class         = "PriceClass_100"

  origin {
    domain_name              = aws_s3_bucket.site.bucket_regional_domain_name
    origin_id                = "s3Origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id

    # Terraform requires this block even with OAC; leave OAI empty
    s3_origin_config {
      origin_access_identity = ""
    }
  }

  default_cache_behavior {
    target_origin_id       = "s3Origin"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    # AWS Managed: CachingOptimized
    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
  }

  custom_error_response {
    error_code         = 404
    response_code      = 404
    response_page_path = "/${var.error_document}"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true # HTTPS on *.cloudfront.net
  }

  depends_on = [aws_s3_bucket_public_access_block.site]
}

# Allow CloudFront (via OAC) to read from the private bucket
data "aws_iam_policy_document" "allow_cf_oac" {
  statement {
    sid     = "AllowCloudFrontReadViaOAC"
    effect  = "Allow"
    actions = ["s3:GetObject"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    resources = ["${aws_s3_bucket.site.arn}/*"]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.cdn.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "allow_cf_oac" {
  bucket     = aws_s3_bucket.site.id
  policy     = data.aws_iam_policy_document.allow_cf_oac.json
  depends_on = [aws_cloudfront_distribution.cdn]
}
