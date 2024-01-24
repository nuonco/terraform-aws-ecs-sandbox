locals {
  prefix         = (var.prefix_override != "" ? var.prefix_override : var.nuon_id)
  install_region = var.region
  tags           = merge({ nuon_id = var.nuon_id }, var.tags)
  nuon_id        = var.nuon_id
  cluster_name   = (var.prefix_override != "" ? var.prefix_override : var.nuon_id)

  /* external_dns = { */
  /*   registry           = "txt" */
  /*   provider           = "aws" */
  /*   policy             = "sync" */
  /*   triggerLoopOnEvent = true */
  /*   interval           = "15m" */
  /* } */
}

variable "prefix_override" {
  type        = string
  description = "The resource prefix to override, otherwise defaults to the nuon install id"
  default     = ""
}

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

  validation {
    condition     = contains(["us-east-1", "us-east-2", "us-west-1", "us-west-2", ], var.region)
    error_message = "${var.region} is currently unsupported"
  }
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
