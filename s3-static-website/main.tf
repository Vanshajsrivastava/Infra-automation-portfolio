terraform {
  required_version = ">= 1.6.0"
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


resource "aws_s3_bucket" "site" {
  bucket = var.bucket_name
  tags   = var.tags
}

# Relax bucket-level Block Public Access so a public-read policy can attach.
# (If your ACCOUNT-level block is ON, you'll still be blocked — in that case use CloudFront+OAC.)
resource "aws_s3_bucket_public_access_block" "site" {
  bucket                  = aws_s3_bucket.site.id
  block_public_acls       = false
  ignore_public_acls      = false
  block_public_policy     = false
  restrict_public_buckets = false
}

# Static website hosting (HTTP-only)
resource "aws_s3_bucket_website_configuration" "site" {
  bucket = aws_s3_bucket.site.id

  index_document {
    suffix = var.index_document
  }

  error_document {
    key = var.error_document
  }
}

# Public read of OBJECTS (not bucket listing)
data "aws_iam_policy_document" "public_read" {
  statement {
    sid     = "PublicReadGetObject"
    actions = ["s3:GetObject"]
    effect  = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = ["${aws_s3_bucket.site.arn}/*"]
  }
}

# Make sure the public-access-block change happens BEFORE attaching the policy.
resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.site.id
  policy = data.aws_iam_policy_document.public_read.json

  depends_on = [aws_s3_bucket_public_access_block.site]
}


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

# Helper to get extension in lowercase
locals {
  site_files = fileset("${path.module}/site", "**")
  file_ext_map = { for f in local.site_files :
    f => lower(element(split(".", f), length(split(".", f)) - 1))
    if length(split(".", f)) > 1
  }
}

resource "aws_s3_object" "files" {
  for_each     = toset(local.site_files)
  bucket       = aws_s3_bucket.site.id
  key          = each.value
  source       = "${path.module}/site/${each.value}"
  etag         = filemd5("${path.module}/site/${each.value}")
  content_type = lookup(local.mime_types, lookup(local.file_ext_map, each.value, ""), null)
  # HTML no-cache; assets cache long
  cache_control = contains(["html", "htm"], lookup(local.file_ext_map, each.value, "")) ? "no-cache" : "public, max-age=31536000, immutable"
}


# output "website_endpoint" {
#   description = "S3 static website URL (HTTP only)"
#   value       = "http://${aws_s3_bucket.site.bucket}.s3-website.${var.region}.amazonaws.com"
# }
