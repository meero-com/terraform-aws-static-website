output "cache_invalidation_command" {
  description = "CloudFront edge cache invalidation command. /path/to/invalidation/resource is like /index.html /error.html"
  value = "aws cloudfront create-invalidation --profile ${var.aws["profile"]} --distribution-id ${aws_cloudfront_distribution.web_dist.id} --paths /path/to/invalidation/resource"
}
