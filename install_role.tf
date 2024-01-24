data "aws_iam_policy_document" "install" {
  statement {
    effect = "Allow"
    actions = [
      "ecs:*",
    ]
    resources = [module.ecs_cluster.cluster_arn, ]
  }

  statement {
    effect = "Allow"
    actions = [
      "elasticfilesystem:*",
      "ecs:*",
      "logs:*",
      "ec2:*",
      "iam:PassRole",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "install" {
  name   = "${local.prefix}-install"
  policy = data.aws_iam_policy_document.install.json
}

data "aws_iam_policy_document" "install_trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole", ]

    principals {
      type = "AWS"
      identifiers = [
        var.nuon_runner_install_trust_iam_role_arn,
      ]
    }
  }
}

module "install_iam_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = ">= 5.1.0"

  create_role       = true
  role_requires_mfa = false

  role_name                       = "${local.prefix}-install"
  create_custom_role_trust_policy = true
  custom_role_trust_policy        = data.aws_iam_policy_document.install_trust.json
  custom_role_policy_arns         = [aws_iam_policy.install.arn, ]
}
