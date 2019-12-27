variable "function_name" {
  default = "opsbot_lambda"
}

variable "handler" {
  default = "opsbot.handler.sns_handler"
}

variable "runtime" {
  default = "python3.8"
}

# Function
resource "aws_lambda_function" "opsbot_function" {
  role             = aws_iam_role.opsbot_role.arn
  handler          = var.handler
  runtime          = var.runtime
  function_name    = var.function_name
  s3_bucket        = "kylev-utility"
  s3_key           = "opsbot/lambda.zip"

  lifecycle {
    ignore_changes = [s3_key]
  }
}

# API Gateway
resource "aws_api_gateway_rest_api" "opsbot_api" {
  name        = "OpsbotApi"
  description = "Opsbot HTTP API."
}

resource "aws_api_gateway_resource" "opsbot_gw_resource" {
  rest_api_id = aws_api_gateway_rest_api.opsbot_api.id
  parent_id   = aws_api_gateway_rest_api.opsbot_api.root_resource_id
  path_part   = "opsbot"
}

resource "aws_api_gateway_method" "opsbot_method" {
  rest_api_id   = aws_api_gateway_rest_api.opsbot_api.id
  resource_id   = aws_api_gateway_resource.opsbot_gw_resource.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "opsbot_integration" {
  rest_api_id = aws_api_gateway_rest_api.opsbot_api.id
  resource_id = aws_api_gateway_method.opsbot_method.resource_id
  http_method = aws_api_gateway_method.opsbot_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.opsbot_function.invoke_arn
}

resource "aws_api_gateway_deployment" "opsbot_deployment_test" {
  depends_on = [
    aws_api_gateway_integration.opsbot_integration,
  ]

  rest_api_id = aws_api_gateway_rest_api.opsbot_api.id
  stage_name  = "testing"
}

resource "aws_lambda_permission" "opsbot_lambda_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.opsbot_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn   = "${aws_api_gateway_rest_api.opsbot_api.execution_arn}/*/*"
}

# Permissions
data "aws_iam_policy_document" "opsbot_assume_policy_doc" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "opsbot_exec_policy_doc" {
  statement {
    sid = "CloudwatchLogging"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = ["arn:aws:logs:*:*:*"]
  }
}

resource "aws_iam_policy" "opsbot_exec_policy" {
  policy = data.aws_iam_policy_document.opsbot_exec_policy_doc.json
}

resource "aws_iam_role" "opsbot_role" {
  name               = "OpsbotRole"
  path               = "/"
  description        = "Things Opsbot is allowed to do."
  assume_role_policy = data.aws_iam_policy_document.opsbot_assume_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "opsbot_role_attachment" {
  role       = aws_iam_role.opsbot_role.name
  policy_arn = aws_iam_policy.opsbot_exec_policy.arn
}

# Publish our presence
resource "aws_ssm_parameter" "circleci_invoke_url" {
  name  = "/circleci/shared/env/opsbot_api_url"
  type  = "SecureString"
  value = aws_api_gateway_deployment.opsbot_deployment_test.invoke_url
}
