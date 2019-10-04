variable "service_name" {
  description = "tagged with service name"
}
variable "aws_profile" {
  description = "aws profile name"
}
variable "domain_names" {
  description = "domain names"
  type        = list(string)
}
variable "cloudfront_origin_path" {
  default     = "/"
  description = "Origin path of CloudFront"
}
variable "route53_zone_id" {
  description = "Route53 Zone ID"
}
variable "s3_bucket_name" {
  description = "S3 bucket name"
}
variable "save_access_log" {
  description = "whether save cloudfront access log to S3"
  type        = bool
  default     = false
}
variable "activate_lambda_sign" {
  description = "Activate the Lambda Sign feature"
  type        = bool
  default     = true
}
variable "lambda" {
  type        = map(string)
  default     = {}
  description = "Lambda@edge values for S3 Signature"
}
