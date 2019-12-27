data "aws_iam_policy_document" "circleci" {
  statement {
    sid = "CdArtifactsBucket"

    actions = [
      "s3:GetBucketLocation",
    ]

    resources = [
      "arn:aws:s3:::kylev-utility",
    ]
  }

  statement {
    sid = "CdArtifactsKeyspace"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
    ]

    resources = [
      "arn:aws:s3:::kylev-utility/opsbot/*",
    ]
  }

  statement {
    sid = "DeployFunction"

    actions = [
      "lambda:UpdateFunctionCode",
    ]

    resources = [
      aws_lambda_function.opsbot_function.arn
    ]
  }

  statement {
    sid       = "CdConfigVars"
    actions   = ["ssm:GetParametersByPath"]
    resources = ["arn:aws:ssm:*:*:parameter/circleci/*"]
  }
}

resource "aws_iam_policy" "circleci_policy" {
  name   = "circleci_policy"
  path   = "/"
  policy = data.aws_iam_policy_document.circleci.json
}

# Static configs and secrets.
resource "aws_ssm_parameter" "circleci_invoke_url" {
  name  = "/circleci/shared/env/opsbot_api_url"
  type  = "String"
  value = aws_api_gateway_deployment.opsbot_deployment_test.invoke_url
}
