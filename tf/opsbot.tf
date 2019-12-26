variable "function_name" {
  default = "opsbot_lambda"
}

variable "handler" {
  default = "opsbot.handler.sns_handler"
}

variable "runtime" {
  default = "python3.8"
}

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
