// Instantiate a minimal version of the module for testing
provider "aws" {
  region = "us-east-1"
}

resource "random_id" "testing_suffix" {
  byte_length = 4
}

locals {
  administrator_arns = [
    "arn:aws:iam::139710491120:user/ci",
    "arn:aws:iam::139710491120:user/skuenzli",
  ]

  read_data_arns = [
    "arn:aws:iam::139710491120:user/skuenzli",
    "arn:aws:sts::139710491120:federated-user/skuenzli"
  ]

  write_data_arns = "${local.read_data_arns}"

  delete_data_arns = ["arn:aws:iam::139710491120:user/skuenzli"]
}


module "it_minimal" {
  source = "../../../" //minimal integration test

  logical_name = "${var.logical_name}-${random_id.testing_suffix.hex}"
  region       = "${var.region}"

  org   = "${var.org}"
  owner = "${var.owner}"
  env   = "${var.env}"
  app   = "${var.app}"

  allow_administer_resource_arns = "${local.administrator_arns}"
  allow_read_data_arns           = "${local.read_data_arns}"
  allow_write_data_arns          = "${local.write_data_arns}"

  # unused: allow_delete_data_arns          = [] (default)
}

variable "logical_name" {
  type = "string"
}

variable "region" {
  type = "string"
}

variable "org" {
  type = "string"
}

variable "owner" {
  type = "string"
}

variable "env" {
  type = "string"
}

variable "app" {
  type = "string"
}

output "module_under_test-key-id" {
  value = "${module.it_minimal.key_id}"
}

