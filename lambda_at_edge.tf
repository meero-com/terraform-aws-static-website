resource "aws_lambda_function" "this" {
  count         = var.activate_lambda_sign ? 1 : 0
  filename      = var.lambda["filename"]
  runtime       = "nodejs12.x"
  function_name = var.lambda["function_name"]
  handler       = "src/lambda.default"
  role          = aws_iam_role.iam_for_lambda[count.index].arn
  publish       = true
}

resource "aws_iam_role" "iam_for_lambda" {
  count              = var.activate_lambda_sign ? 1 : 0
  name               = var.lambda["role_name"]
  assume_role_policy = var.lambda["assume_role_policy"]
}


data "aws_iam_policy_document" "policy" {
  count = var.activate_lambda_sign ? 1 : 0
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
  count  = var.activate_lambda_sign ? 1 : 0
  name   = var.lambda["function_name"]
  policy = data.aws_iam_policy_document.policy[count.index].json
}

resource "aws_iam_policy_attachment" "lambda-attach" {
  count      = var.activate_lambda_sign ? 1 : 0
  name       = "lambda-attachment"
  roles      = [aws_iam_role.iam_for_lambda[count.index].name]
  policy_arn = aws_iam_policy.policy_for_lambda[count.index].arn
}

