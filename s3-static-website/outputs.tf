output "bucket_name" {
  value       = aws_s3_bucket.site.bucket
  description = "S3 bucket name"
}

output "website_endpoint" {
  value       = "http://${aws_s3_bucket.site.bucket}.s3-website.${var.region}.amazonaws.com"
  description = "S3 static website URL (HTTP only)"
}
