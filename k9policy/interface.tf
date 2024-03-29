variable "allow_administer_resource_arns" {
  type        = list(string)
  default     = []
  description = "The list of fully-qualified AWS IAM ARNs authorized to administer this bucket. Wildcards are supported. e.g. arn:aws:iam::12345678910:user/ci or arn:aws:iam::12345678910:role/app-backend-*"

  validation {
    condition     = length(var.allow_administer_resource_arns) > 0
    error_message = "A key administrator is required, but none were specified."
  }
}

variable "allow_administer_resource_test" {
  type        = string
  default     = "ArnEquals"
  description = "The IAM test to use in the policy statement condition, should be one of 'ArnEquals' (default) or 'ArnLike'"
}

variable "allow_read_config_arns" {
  type        = list(string)
  default     = []
  description = "The list of fully-qualified AWS IAM ARNs authorized to read configuration of this key. Wildcards are supported. e.g. arn:aws:iam::12345678910:user/ci or arn:aws:iam::12345678910:role/app-backend-*"
}

variable "allow_read_config_test" {
  type        = string
  default     = "ArnEquals"
  description = "The IAM test to use in the policy statement condition, should be one of 'ArnEquals' (default) or 'ArnLike'"
}

variable "allow_read_data_arns" {
  type        = list(string)
  default     = []
  description = "The list of fully-qualified AWS IAM ARNs authorized to read data in this bucket. Wildcards are supported. e.g. arn:aws:iam::12345678910:user/ci or arn:aws:iam::12345678910:role/app-backend-*"
}

variable "allow_read_data_test" {
  type        = string
  default     = "ArnEquals"
  description = "The IAM test to use in the policy statement condition, should be one of 'ArnEquals' (default) or 'ArnLike'"
}

variable "allow_write_data_arns" {
  type        = list(string)
  default     = []
  description = "The list of fully-qualified AWS IAM ARNs authorized to write data in this bucket. Wildcards are supported. e.g. arn:aws:iam::12345678910:user/ci or arn:aws:iam::12345678910:role/app-backend-*"
}

variable "allow_write_data_test" {
  type        = string
  default     = "ArnEquals"
  description = "The IAM test to use in the policy statement condition, should be one of 'ArnEquals' (default) or 'ArnLike'"
}

variable "allow_delete_data_arns" {
  type        = list(string)
  default     = []
  description = "The list of fully-qualified AWS IAM ARNs authorized to delete data in this bucket. Wildcards are supported. e.g. arn:aws:iam::12345678910:user/ci or arn:aws:iam::12345678910:role/app-backend-*"
}

variable "allow_delete_data_test" {
  type        = string
  default     = "ArnEquals"
  description = "The IAM test to use in the policy statement condition, should be one of 'ArnEquals' (default) or 'ArnLike'"
}

variable "allow_custom_actions" {
  type = list(string)

  # the AllowRestrictedCustomActions statement needs a valid API action, so default to something innocuous: kms:DescribeKey
  default     = ["kms:DescribeKey"]
  description = "A custom list of KMS API actions to authorize ARNs listed in `allow_custom_actions_arns` to execute against this bucket."
}

variable "allow_custom_actions_arns" {
  type        = list(string)
  default     = []
  description = "The list of fully-qualified AWS IAM ARNs authorized to execute the custom actions against this bucket. Wildcards are supported. e.g. arn:aws:iam::12345678910:user/ci or arn:aws:iam::12345678910:role/app-backend-*"
}

variable "allow_custom_arns_test" {
  type        = string
  default     = "ArnEquals"
  description = "The IAM test to use in the policy statement condition, should be one of 'ArnEquals' (default) or 'ArnLike'"
}

output "policy_json" {
  value = data.aws_iam_policy_document.resource_policy.json
}

