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
  role             = aws_iam_role.opsbot_exec_role.arn
  handler          = var.handler
  runtime          = var.runtime
  function_name    = var.function_name
  s3_bucket        = "kylev-utility"
  s3_key           = "opsbot/lambda.zip"

  lifecycle {
    ignore_changes = [s3_key]
  }
}

resource "aws_iam_role" "opsbot_exec_role" {
  path        = "/"
  description = "Allows Lambda Function to call AWS services on your behalf."

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}
