data "aws_iam_policy_document" "circleci" {
  statement {
    sid = "OpsbotArtifactsBucket"

    actions = [
      "s3:GetBucketLocation",
    ]

    resources = [
      "arn:aws:s3:::kylev-utility",
    ]
  }

  statement {
    sid = "OpsbotArtifactsKeyspace"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
    ]

    resources = [
      "arn:aws:s3:::kylev-utility/opsbot/*",
    ]
  }

  statement {
    sid = "OpsbotDeploy"

    actions = [
      "lambda:UpdateFunctionCode",
    ]

    resources = [
      aws_lambda_function.opsbot_function.arn
    ]
  }
}

resource "aws_iam_policy" "circleci_policy" {
  name   = "circleci_policy"
  path   = "/"
  policy = data.aws_iam_policy_document.circleci.json
}
