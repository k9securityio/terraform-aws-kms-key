data "aws_caller_identity" "current" {}

locals {
  tests_used_in_statements = [
    var.allow_administer_resource_test,
    var.allow_custom_arns_test,
    var.allow_delete_data_test,
    var.allow_read_data_test,
    var.allow_read_config_test,
    var.allow_write_data_test,
  ]
  like_used_in_test_condition = contains(local.tests_used_in_statements, "ArnLike")

  # future work: retrieve action mappings from k9 api
  actions_administer_resource = sort(
    distinct(
      compact(
        split(
          "\n",
          file(
            "${path.module}/k9-access_capability.administer-resource.tsv",
          ),
        ),
      ),
    ),
  )
  actions_read_config = sort(
    distinct(
      compact(
        split(
          "\n",
          file("${path.module}/k9-access_capability.read-config.tsv"),
        ),
      ),
    ),
  )
  actions_use_resource = []
  actions_read_data = sort(
    distinct(
      compact(
        split(
          "\n",
          file("${path.module}/k9-access_capability.read-data.tsv"),
        ),
      ),
    ),
  )
  actions_write_data = sort(
    distinct(
      compact(
        split(
          "\n",
          file("${path.module}/k9-access_capability.write-data.tsv"),
        ),
      ),
    ),
  )
  actions_delete_data = sort(
    distinct(
      compact(
        split(
          "\n",
          file("${path.module}/k9-access_capability.delete-data.tsv"),
        ),
      ),
    ),
  )

  account_root_user_arn="arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
}

data "aws_iam_policy_document" "resource_policy" {
  version = "2012-10-17"
  
  statement {
    sid = "AllowRestrictedAdministerResource"

    actions = local.actions_administer_resource

    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    condition {
      test     = var.allow_administer_resource_test
      values   = var.allow_administer_resource_arns
      variable = "aws:PrincipalArn"
    }
  }

  statement {
    sid = "AllowRestrictedReadConfig"

    actions = local.actions_read_config

    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    condition {
      test     = var.allow_read_config_test
      values   = var.allow_read_config_arns
      variable = "aws:PrincipalArn"
    }
  }
  
  statement {
    sid = "AllowRestrictedReadData"

    actions = local.actions_read_data

    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    condition {
      test     = var.allow_read_data_test
      values   = var.allow_read_data_arns
      variable = "aws:PrincipalArn"
    }
  }

  statement {
    sid = "AllowRestrictedWriteData"

    actions = local.actions_write_data

    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    condition {
      test     = var.allow_write_data_test
      values   = var.allow_write_data_arns
      variable = "aws:PrincipalArn"
    }
  }

  statement {
    sid = "AllowRestrictedDeleteData"

    actions = local.actions_delete_data

    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    condition {
      test     = var.allow_delete_data_test
      values   = var.allow_delete_data_arns
      variable = "aws:PrincipalArn"
    }
  }

  statement {
    sid = "AllowRestrictedCustomActions"

    actions = var.allow_custom_actions

    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    condition {
      test     = var.allow_custom_arns_test
      values   = var.allow_custom_actions_arns
      variable = "aws:PrincipalArn"
    }
  }

}
