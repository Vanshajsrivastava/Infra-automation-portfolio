output "bucket_name" {
  description = "S3 bucket name"
  value       = aws_s3_bucket.site.bucket
}

output "cloudfront_domain" {
  description = "CloudFront HTTPS URL"
  value       = aws_cloudfront_distribution.cdn.domain_name
}

output "cloudfront_distribution_id" {
  description = "ID for invalidations / status checks"
  value       = aws_cloudfront_distribution.cdn.id
}
