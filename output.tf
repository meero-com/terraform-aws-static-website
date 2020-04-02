output "cache_invalidation_command" {
  description = "CloudFront edge cache invalidation command. /path/to/invalidation/resource is like /index.html /error.html"
  value = "aws cloudfront create-invalidation --profile ${var.aws["profile"]} --distribution-id ${aws_cloudfront_distribution.web_dist.id} --paths /path/to/invalidation/resource"
}
output "distribution_domain_name" {
  description = "CloudFront distribution domain name"
  value       = aws_cloudfront_distribution.web_dist.domain_name
}
output "distribution_zone_id" {
  description = "CloudFront distribution zone ID"
  value       = aws_cloudfront_distribution.web_dist.hosted_zone_id
}
