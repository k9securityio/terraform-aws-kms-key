locals {
  key_name = "${var.org}-${var.env}-${var.logical_name}"
}

module "context" {
  source = "git@github.com:k9securityio/tf_context.git?ref=v0.2.0"

  name = local.key_name

  owner = var.owner
  env   = var.env
  app   = var.app
  role  = var.role

  business_unit    = var.business_unit
  business_process = var.business_process

  cost_center       = var.cost_center
  compliance_scheme = var.compliance_scheme

  confidentiality = var.confidentiality
  integrity       = var.integrity
  availability    = var.availability

  additional_tags = var.additional_tags
}

locals {
  use_custom_policy = length(var.policy) > 0

  policy = local.use_custom_policy ? var.policy : module.resource_policy.policy_json
}

module "resource_policy" {
  source = "./k9policy"

  allow_administer_resource_arns = var.allow_administer_resource_arns
  allow_administer_resource_test = var.allow_administer_resource_test

  allow_read_data_arns = var.allow_read_data_arns
  allow_read_data_test = var.allow_read_data_test

  allow_write_data_arns = var.allow_write_data_arns
  allow_write_data_test = var.allow_write_data_test

  allow_delete_data_arns = var.allow_delete_data_arns
  allow_delete_data_test = var.allow_delete_data_test
}

resource "aws_kms_key" "key" {
  description = "Key for ${var.logical_name} in ${var.env}"
  is_enabled  = var.enabled

  customer_master_key_spec = var.customer_master_key_spec
  key_usage                = var.key_usage

  deletion_window_in_days = var.deletion_window_in_days
  enable_key_rotation     = var.enable_key_rotation
  tags                    = module.context.tags

  policy = local.policy
}

resource "aws_kms_alias" "alias" {
  name          = "alias/${local.key_name}"
  target_key_id = aws_kms_key.key.key_id
}

