# cloudfrontのSSL証明書はus-east-1で作成する必要がある
provider "aws" {
  alias = "us-east-1"
  region = "us-east-1"
  profile = var.aws["profile"]
  assume_role {
    role_arn     = var.aws["role_arn"]
    session_name = "TERRAFORM"
  }
}

resource "aws_acm_certificate" "cert" {
  provider = "aws.us-east-1"
  domain_name = var.domain_names[0]
  subject_alternative_names = slice(var.domain_names, 1, length(var.domain_names))
  validation_method = "DNS"

  tags = {
    Name = "${var.service_name} web"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "cert" {
  provider = "aws.us-east-1"
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = aws_route53_record.cert_validation.*.fqdn
}
