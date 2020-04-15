data "aws_iam_policy_document" "bucket_policy" {
  statement {
    sid = "AllowCloudFront"
    effect = "Allow"
    actions = [
      "s3:GetObject"
    ]
    resources = [
      "arn:aws:s3:::${var.s3_bucket_name}/*"
    ]

    principals {
      type = "AWS"
      identifiers = ["arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${aws_cloudfront_origin_access_identity.origin_access_identity.id}"]
    }
  }
  dynamic "statement" {
    for_each = [ for s in var.bucket_policy : {
      actions   = s.actions
      effect    = s.effect
      resources = s.resources
    }]
    content {
      actions   = lookup(statement.value, "actions", null)
      effect    = lookup(statement.value, "effect", null)
      resources = lookup(statement.value, "resources", null)
    }
  }
}

resource "aws_s3_bucket" "hosting" {
  bucket = var.s3_bucket_name
  policy = data.aws_iam_policy_document.bucket_policy.json

  versioning {
    enabled = true
  }
  cors_rule {
    allowed_headers = ["Authorization"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["*"]
    expose_headers  = []
    max_age_seconds = 3000
  }

}
