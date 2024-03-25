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
  description = "The resource prefix to override, otherwise defaults to the nuon install id"
  default     = ""
}

# Automatically set by Nuon when provisioned.

variable "nuon_id" {
  type        = string
  description = "The nuon id for this install. Used for naming purposes."
}

variable "assume_role_arn" {
  type        = string
  description = "The role arn to assume during provisioning of this sandbox."
}

variable "tags" {
  type        = map(any)
  description = "List of custom tags to add to the install resources. Used for taxonomic purposes."
}

variable "region" {
  type        = string
  description = "The region to launch the cluster in"
}

// NOTE: if you would like to create an internal load balancer, with TLS, you will have to use the public domain.
variable "internal_root_domain" {
  type        = string
  description = "internal root domain."
}

variable "public_root_domain" {
  type        = string
  description = "public root domain."
}

variable "nuon_runner_install_trust_iam_role_arn" {
  type        = string
  description = "IAM role to grant Nuon access to install the runner."
}
