output "runner" {
  value = {
    runner_iam_role_arn  = module.runner_iam_role.iam_role_arn
    odr_iam_role_arn     = module.odr_iam_role.iam_role_arn
    install_iam_role_arn = module.install_iam_role.iam_role_arn
  }
}

output "ecs_cluster" {
  // NOTE: these are declared here -
  // https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest?tab=outputs
  value = {
    arn  = module.ecs_cluster.cluster_arn,
    id   = module.ecs_cluster.cluster_id,
    name = local.cluster_name,
  }
}

output "vpc" {
  // NOTE: these are declared here -
  // https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest?tab=outputs
  value = {
    name = module.vpc.name
    id   = module.vpc.name
    cidr = module.vpc.vpc_cidr_block
    azs  = module.vpc.azs

    private_subnet_cidr_blocks = module.vpc.private_subnets_cidr_blocks
    private_subnet_ids         = module.vpc.private_subnets

    public_subnet_cidr_blocks = module.vpc.public_subnets_cidr_blocks
    public_subnet_ids         = module.vpc.public_subnets

    default_security_group_id = aws_security_group.runner.id
    # default_security_group_arn = aws_security_group.runner.arn
  }
}

output "account" {
  value = {
    id     = data.aws_caller_identity.current.account_id
    region = var.region
  }
}

output "ecr" {
  value = {
    repository_url  = module.ecr.repository_url
    repository_arn  = module.ecr.repository_arn
    repository_name = local.prefix
    registry_id     = module.ecr.repository_registry_id
    registry_url    = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com"
  }
}

output "public_domain" {
  value = {
    nameservers = aws_route53_zone.public.name_servers
    name        = aws_route53_zone.public.name
    zone_id     = aws_route53_zone.public.id
  }
}

output "internal_domain" {
  value = {
    nameservers = aws_route53_zone.internal.name_servers
    name        = aws_route53_zone.internal.name
    zone_id     = aws_route53_zone.internal.id
  }
}
