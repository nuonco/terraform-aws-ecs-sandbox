data "aws_iam_policy_document" "runner_install" {
  statement {
    effect = "Allow"
    actions = [
      "ecs:CreateCapacityProvider",
      "ecs:DescribeCapacityProviders",
      "ecs:DescribeClusters",
      "ecs:ListTagsForResource",
      "ecs:PutClusterCapacityProviders",
      "ecs:TagResource"
    ]
    resources = [module.ecs_cluster.cluster_arn, ]
  }
  statement {
    effect = "Allow"
    actions = [
      "elasticfilesystem:*",
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "ec2:CreateNetworkAclEntry",
      "ec2:DeleteNetworkAclEntry",
      "elasticfilesystem:*",
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "iam:AttachRolePolicy",
      "iam:CreateOpenIDConnectProvider",
      "iam:CreatePolicy",
      "iam:CreatePolicyVersion",
      "iam:CreateRole",
      "iam:CreateServiceLinkedRole",
      "iam:GetOpenIDConnectProvider",
      "iam:GetPolicy",
      "iam:GetPolicyVersion",
      "iam:GetRole",
      "iam:GetRolePolicy",
      "iam:ListAttachedRolePolicies",
      "iam:ListRolePolicies",
      "iam:PassRole",
      "iam:PutRolePolicy",
      "iam:TagOpenIDConnectProvider",
      "iam:TagPolicy",
      "iam:TagRole",
      "iam:UpdateAssumeRolePolicy",
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:DescribeLogGroups",
      "logs:ListTagsLogGroup",
      "logs:PutRetentionPolicy",
      "logs:TagLogGroup",
      "logs:TagResource",
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
