data "aws_iam_policy_document" "runner" {
  statement {
    effect    = "Allow"
    actions   = ["ecr:*"]
    resources = [module.ecs_cluster.cluster_arn, ]
  }

  statement {
    effect    = "Allow"
    actions   = ["logs:*"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "runner" {
  name   = "${local.prefix}-runner"
  policy = data.aws_iam_policy_document.runner.json
}

data "aws_iam_policy_document" "runner_trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole", ]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

module "runner_iam_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = ">= 5.1.0"

  create_role       = true
  role_requires_mfa = false

  role_name                       = "${local.prefix}-runner"
  create_custom_role_trust_policy = true
  custom_role_trust_policy        = data.aws_iam_policy_document.runner_trust.json
  custom_role_policy_arns         = [aws_iam_policy.runner.arn, ]
}
