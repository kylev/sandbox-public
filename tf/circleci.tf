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
    sid = "CdConfigVars"
    actions = [
      "ssm:DescribeParameters",
      "ssm:GetParametersByPath",
    ]
    resources = [
      "arn:aws:ssm:*:*:parameter/circleci/shared/*",
      "arn:aws:ssm:*:*:parameter/circleci/sandbox-public/*",
    ]
  }

  statement {
    sid = "CdEcrArtifacts"
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage",
      "ecr:GetLifecyclePolicy",
      "ecr:GetLifecyclePolicyPreview",
      "ecr:ListTagsForResource",
      "ecr:DescribeImageScanFindings",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:PutImage",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "circleci_policy" {
  name   = "circleci_policy"
  path   = "/"
  policy = data.aws_iam_policy_document.circleci.json
}

# Static configs and secrets.
resource "aws_ssm_parameter" "circleci_invoke_url" {
  name  = "/circleci/shared/env/OPSBOT_API_URL"
  type  = "SecureString"
  value = "${aws_api_gateway_deployment.opsbot_deployment_test.invoke_url}/opsbot"
}

resource "aws_ssm_parameter" "circleci_ecr" {
  name  = "/circleci/sandbox-public/env/AWS_ECR_ACCOUNT_URL"
  type  = "SecureString"
  value = split("/", aws_ecr_repository.rubyapp_ecr_repo.repository_url)[0]
}
