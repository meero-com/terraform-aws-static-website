resource "aws_lambda_function" "this" {
  filename      = var.lambda["filename"]
  runtime       = "nodejs8.10"
  function_name = var.lambda["function_name"]
  handler       = "src/lambda.default"
  role          = aws_iam_role.iam_for_lambda.arn
  publish       = true
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = var.lambda["role_name"]
  assume_role_policy = var.lambda["assume_role_policy"]
}


data "aws_iam_policy_document" "policy" {
  dynamic "statement" {
    for_each = [for s in var.lambda_policy : {
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

resource "aws_iam_policy" "policy_for_lambda" {
  name   = var.lambda["function_name"]
  policy = data.aws_iam_policy_document.policy.json
}

resource "aws_iam_policy_attachment" "lambda-attach" {
  name       = "lambda-attachment"
  roles      = [aws_iam_role.iam_for_lambda.name]
  policy_arn = aws_iam_policy.policy_for_lambda.arn
}

