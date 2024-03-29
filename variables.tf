locals {
  nuon_id        = var.nuon_id
  prefix         = (var.prefix_override != "" ? var.prefix_override : var.nuon_id)
  install_region = var.region
  tags = merge(
    var.tags,
    { nuon_id = var.nuon_id },
  )
}

variable "prefix_override" {
  type        = string
  description = "Prefix used to name sandbox resources. Will default to the Nuon ID."
  default     = ""
}

# Automatically set by Nuon when provisioned.

variable "nuon_id" {
  type        = string
  description = "An ID used to name resources. Defaults to the install ID. Will be set by Nuon during the install provision process."
}

variable "assume_role_arn" {
  type        = string
  description = "The ARN of the AWS IAM Role to assume during provisioning of the sandbox. Will be set by Nuon during the install provision process."
}

variable "tags" {
  type        = map(any)
  description = "List of tags to add to all sandbox resources (that support tags). Used for taxonomic purposes. Will be set by Nuon during the install provision process."
}

variable "region" {
  type        = string
  description = "The AWS region to provision the sandbox in. Will be set by Nuon during the install provision process."
}

// NOTE: if you would like to create an internal load balancer, with TLS, you will have to use the public domain.
variable "internal_root_domain" {
  type        = string
  description = "The internal root domain of the sandbox. Will be set by Nuon during the install provision process."
}

variable "public_root_domain" {
  type        = string
  description = "The public root domain of the sandbox. Will be set by Nuon during the install provision process."
}

variable "nuon_runner_install_trust_iam_role_arn" {
  type        = string
  description = "The ARN of the AWS IAM Role to grant Nuon access to install the ECS Fargate runner. Will be set by Nuon during the install provision process."
}
