data "aws_iam_policy_document" "runner_install" {
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

resource "aws_iam_policy" "runner_install" {
  name   = "${local.prefix}-runner-install"
  policy = data.aws_iam_policy_document.runner_install.json
}

data "aws_iam_policy_document" "runner_install_trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole", ]

    principals {
      type = "AWS"
      identifiers = [
        var.runner_install_role,
      ]
    }
  }
  # NOTE(fd/jm): allow the role to assume itself. The ARN is constructed manually because
  #              we won't have it until after it's been created
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole", ]

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${aws.account_id}:role/${data.aws_iam_policy.runner_install.name}"
      ]
    }
  }
}

module "runner_install_iam_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = ">= 5.1.0"

  create_role       = true
  role_requires_mfa = false

  role_name                       = "${local.prefix}-runner-install"
  create_custom_role_trust_policy = true
  custom_role_trust_policy        = data.aws_iam_policy_document.runner_install_trust.json
  custom_role_policy_arns         = [aws_iam_policy.runner_install.arn, ]
}
