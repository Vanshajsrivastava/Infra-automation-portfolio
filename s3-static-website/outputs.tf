output "bucket_name" {
  description = "S3 bucket name"
  value       = nonsensitive(aws_s3_bucket.site.bucket)
}

output "cloudfront_distribution_id" {
  description = "ID for CloudFront invalidations"
  value       = aws_cloudfront_distribution.cdn.id
}

output "cloudfront_domain" {
  description = "CloudFront domain"
  value       = aws_cloudfront_distribution.cdn.domain_name
}
