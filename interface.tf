variable "logical_name" {
  type        = string
  description = "Specify the 'logical' name of the key appropriate for the key's primary use case, e.g. media or orders"
}

variable "policy" {
  description = "(optional) fully rendered policy; if unspecified, the policy will be generated from the `allow_*` variables"
  type        = string
  default     = ""
}

variable "deletion_window_in_days" {
  description = "(optional) the length of the pending deletion window in days; defaults to 30 days"
  type        = number
  default     = 30
}

variable "customer_master_key_spec" {
  description = "(optional) specifies whether the key contains a symmetric key or an asymmetric key pair and the encryption algorithms or signing algorithms that the key supports; defaults to SYMMETRIC_DEFAULT"
  type        = string
  default     = "SYMMETRIC_DEFAULT"
}

variable "key_usage" {
  description = "(optional) specifies the intended use of the key; defaults to ENCRYPT_DECRYPT"
  type        = string
  default     = "ENCRYPT_DECRYPT"
}

variable "enable_key_rotation" {
  description = "(optional) enable annual key rotation by AWS"
  type        = bool
  default     = true
}

variable "enabled" {
  description = "(optional) whether the key is enabled for use or not"
  type        = bool
  default     = true
}

variable "org" {
  type        = string
  description = "Short id of the organization that owns the key"
}

variable "owner" {
  type        = string
  description = "Name of the team or department that responsible for the key"
}

variable "env" {
  type        = string
  description = "Name of the environment the key supports"
}

variable "app" {
  type        = string
  description = "Name of the application the key supports"
}

variable "role" {
  type        = string
  description = "The role or function of this resource within the Application's logical architecture, e.g. load balancer, app server, database"
  default     = ""
}

variable "business_unit" {
  type        = string
  description = "The top-level organizational division that owns the resource. e.g. Consumer Retail, Enterprise Solutions, Manufacturing"
  default     = ""
}

variable "business_process" {
  type        = string
  description = "The high-level business process the key supports"
  default     = ""
}

variable "cost_center" {
  type        = string
  description = "The managerial accounting cost center for the key"
  default     = ""
}

variable "compliance_scheme" {
  type        = string
  description = "The regulatory compliance scheme the resource’s configuration should conform to"
  default     = ""
}

variable "confidentiality" {
  type        = string
  description = "Expected Confidentiality level of data protected by the key, e.g. Public, Internal, Confidential, Restricted"
  default     = ""
}

variable "integrity" {
  type        = string
  description = "Expected Integrity level of data protected by the key, e.g. 0.999, 0.9999, 0.99999, 0.999999"
  default     = ""
}

variable "availability" {
  type        = string
  description = "Expected Availability level of data protected by the key, e.g. 0.999, 0.9999, 0.99999, 0.999999"
  default     = ""
}

variable "allow_administer_resource_arns" {
  type        = list(string)
  default     = []
  description = "The list of fully-qualified AWS IAM ARNs authorized to administer this key. Wildcards are supported. e.g. arn:aws:iam::12345678910:user/ci or arn:aws:iam::12345678910:role/app-backend-*"
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
  description = "The list of fully-qualified AWS IAM ARNs authorized to read data protected by this key. Wildcards are supported. e.g. arn:aws:iam::12345678910:user/ci or arn:aws:iam::12345678910:role/app-backend-*"
}

variable "allow_read_data_test" {
  type        = string
  default     = "ArnEquals"
  description = "The IAM test to use in the policy statement condition, should be one of 'ArnEquals' (default) or 'ArnLike'"
}

variable "allow_write_data_arns" {
  type        = list(string)
  default     = []
  description = "The list of fully-qualified AWS IAM ARNs authorized to write data protected by this key. Wildcards are supported. e.g. arn:aws:iam::12345678910:user/ci or arn:aws:iam::12345678910:role/app-backend-*"
}

variable "allow_write_data_test" {
  type        = string
  default     = "ArnEquals"
  description = "The IAM test to use in the policy statement condition, should be one of 'ArnEquals' (default) or 'ArnLike'"
}

variable "allow_delete_data_arns" {
  type        = list(string)
  default     = []
  description = "The list of fully-qualified AWS IAM ARNs authorized to delete data protected by this key. Wildcards are supported. e.g. arn:aws:iam::12345678910:user/ci or arn:aws:iam::12345678910:role/app-backend-*"
}

variable "allow_delete_data_test" {
  type        = string
  default     = "ArnEquals"
  description = "The IAM test to use in the policy statement condition, should be one of 'ArnEquals' (default) or 'ArnLike'"
}

variable "additional_tags" {
  type        = map(string)
  default     = {}
  description = "A map of additional tags to merge with the module's standard tags and apply to the key."
}

output "key_id" {
  value = aws_kms_key.key.id
}

output "key_arn" {
  value = aws_kms_key.key.arn
}

output "key_alias" {
  value = aws_kms_alias.alias.name
}

output "policy_json" {
  value = aws_kms_key.key.policy
}

