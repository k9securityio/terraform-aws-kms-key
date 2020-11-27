// Instantiate a minimal version of the module for testing
provider "aws" {
  region = "us-east-1"
}

resource "random_id" "testing_suffix" {
  byte_length = 4
}

locals {
  testing_suffix_hex = random_id.testing_suffix.hex

  administrator_arns = [
    "arn:aws:iam::139710491120:user/ci",
    "arn:aws:iam::139710491120:user/skuenzli",
    "arn:aws:sts::139710491120:federated-user/skuenzli",
  ]

  write_data_arns = [
      "arn:aws:iam::139710491120:user/skuenzli",
    ]

  read_data_arns = distinct(concat(local.administrator_arns, local.write_data_arns))

  delete_data_arns = ["arn:aws:iam::139710491120:user/skuenzli"]

}

module "it_minimal" {
  source = "../../../"

  logical_name = "${var.logical_name}-${local.testing_suffix_hex}"
  
  org   = var.org
  owner = var.owner
  env   = var.env
  app   = var.app

  allow_administer_resource_arns = local.administrator_arns
  allow_read_data_arns           = local.read_data_arns
  allow_write_data_arns          = local.write_data_arns
  # unused: allow_delete_data_arns          = [] (default)

  deletion_window_in_days = 7
}

// Frequently triggers bug in local provider v2.0.0 & TF 0.12.29
//
//resource "local_file" "it_minimal_policy" {
//  content  = module.it_minimal.policy_json
//  filename = "${path.module}/generated/it_minimal_policy.json"
//}

locals {
  example_administrator_arns = [
    "arn:aws:iam::12345678910:user/ci",
    "arn:aws:iam::12345678910:user/person1",
  ]

  example_read_data_arns = [
    "arn:aws:iam::12345678910:user/person1",
    "arn:aws:iam::12345678910:role/appA",
  ]

  example_write_data_arns = local.example_read_data_arns
}

module "declarative_privilege_policy" {
  source = "../../../k9policy"

  allow_administer_resource_arns = local.example_administrator_arns
  allow_read_data_arns           = local.example_read_data_arns
  allow_write_data_arns          = local.example_write_data_arns
  # unused: allow_delete_data_arns          = [] (default)
  # unused: allow_use_resource_arns         = [] (default)
}

resource "local_file" "declarative_privilege_policy" {
  content  = module.declarative_privilege_policy.policy_json
  filename = "${path.module}/generated/declarative_privilege_policy.json"
}

resource "aws_dynamodb_table" "encrypted" {
  name = "${var.logical_name}-${local.testing_suffix_hex}"
  hash_key = "key"

  attribute {
      name = "key"
      type = "S"
    }

  server_side_encryption {
    enabled = true
    kms_key_arn = module.it_minimal.key_arn
  }

  billing_mode = "PAY_PER_REQUEST"
}

variable "logical_name" {
  type = string
}

variable "org" {
  type = string
}

variable "owner" {
  type = string
}

variable "env" {
  type = string
}

variable "app" {
  type = string
}

output "module_under_test-testing_suffix_hex" {
  value = local.testing_suffix_hex
}

output "module_under_test-key_id" {
  value = module.it_minimal.key_id
}

output "module_under_test-key_arn" {
  value = module.it_minimal.key_arn
}

output "module_under_test-key_alias" {
  value = module.it_minimal.key_alias
}

output "module_under_test-encrypted_ddb_table_id" {
  value = aws_dynamodb_table.encrypted.id
}
