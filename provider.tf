provider "aws" {
  region = local.install_region

  assume_role {
    role_arn = var.assume_role_arn
  }

  default_tags {
    tags = local.tags
  }
}
