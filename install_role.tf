data "aws_iam_policy_document" "runner_install" {
  statement {
    effect = "Allow"
    actions = [
      "ecs:CreateCapacityProvider",
      "ecs:DescribeCapacityProviders",
      "ecs:DescribeClusters",
      "ecs:ListTagsForResource",
      "ecs:PutClusterCapacityProviders",
      "ecs:TagResource",
    ]
    resources = [module.ecs_cluster.cluster_arn, ]
  }

  statement {
    effect = "Allow"
    actions = [
      "ec2:AttachInternetGateway",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:CreateSecurityGroup",
      "ec2:CreateSubnet",
      "ec2:CreateVpc",
      "ec2:Describe*",
      "ec2:ModifySubnetAttribute",
      "ec2:ModifyVpcAttribute",
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "autoscaling:CreateAutoScalingGroup",
      "autoscaling:CreateLaunchConfiguration",
      "autoscaling:Describe*",
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "elasticfilesystem:DescribeAccessPoints",
      "elasticfilesystem:DescribeFileSystems",
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "iam:Passrole",
    ]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:DescribeLogGroups",
      "logs:FilterLogEvents",
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
