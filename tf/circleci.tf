data "aws_iam_policy_document" "circleci" {
  statement {
    sid = "bucket"

    actions = [
      "s3:GetBucketLocation",
    ]

    resources = [
      "arn:aws:s3:::kylev-utility",
    ]
  }

  statement {
    sid = "upload"

    actions = [
      "s3:PutObject",
    ]

    resources = [
      "arn:aws:s3:::kylev-utility/opsbot/*",
    ]
  }
}

resource "aws_iam_policy" "circleci_policy" {
  name   = "circleci_policy"
  path   = "/"
  policy = data.aws_iam_policy_document.circleci.json
}
