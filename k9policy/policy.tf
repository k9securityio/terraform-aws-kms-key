data "aws_caller_identity" "current" {}

locals {
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
}

data "aws_iam_policy_document" "resource_policy" {
  statement {
    # Ensure account's root user retains access to key
    # even if access is removed for all other principals or those principals are removed
    sid = "AllowRootUserToAdministerKey"

    effect = "Allow"
    
    actions = ["kms:*"]

    principals {
      type = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }

    resources = ["*"]
  }

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

  statement {
    sid = "DenyEveryoneElse"

    effect = "Deny"

    actions = ["kms:*"]

    resources = ["*"]

    # Deny access to all IAM principals in the account unless explicitly allowed
    principals {
      type        = "AWS"
      identifiers = [
        data.aws_caller_identity.current.account_id,
      ]
    }

    condition {
      test = "ArnNotEquals"
      values = distinct(
        concat(
          var.allow_administer_resource_arns,
          var.allow_read_data_arns,
          var.allow_write_data_arns,
          var.allow_delete_data_arns,
        ),
      )
      variable = "aws:PrincipalArn"
    }
  }
}
