# Terraform AWS KMS key and policy module #

k9 Security's tf_aws_kms_key helps you protect data by creating an AWS KMS Encryption Key with safe defaults and a 
least-privilege key policy built on the 
[k9 access capability model](https://k9security.io/docs/k9-access-capability-model/).

There are several problems engineers must solve when securing data encryption, especially when sharing an AWS 
account.  To secure your data, you'll need to:

1. configure a couple distinct KMS resources: the key, alias, and resource policy
2. create security policies that allow access by authorized principals and denies everyone else
3. adjust standard Terraform resource configurations which generally mirror AWS API defaults to current best practice
4. capture enough context to scale security, governance, risk, and compliance activities efficiently 

Configuring your intended access can be especially difficult.  First there are complicated interactions between IAM and
resource policies.  Second, IAM policies without resource conditions (e.g. AWS Managed Policies) overprovision access to
all resources of that API resource type.  Learn more about why writing these security policies is hard in this 
[blog post](https://k9security.io/posts/2020/06/why-are-good-aws-security-policies-so-difficult/) 
or [video](https://youtu.be/WIZPSuSoQq4).  A primary access control goal is to prevent an exploit of one application 
leading to the breach of another application's data, e.g. a firewall role being used to steal credit application data.      

This module addresses these problems by helping you declare your intent and let the module worry about the details.
Specify context about your use case and intended access, then the module will:

* create a key and alias named using your context
* generate a least privilege resource policy
* tag resources according to the [k9 Security tagging model](https://k9security.io/docs/guide-to-tagging-cloud-deployments/)

[![CircleCI](https://circleci.com/gh/k9securityio/tf_aws_kms_key.svg?style=svg)](https://circleci.com/gh/k9securityio/tf_aws_kms_key)

## Usage
The root of this repository contains a Terraform module that manages an AWS KMS key ([KMS key API](interface.md)).

The k9 KMS key module allows you to define who should have access to the key in terms of k9's 
[access capability model](https://k9security.io/docs/k9-access-capability-model/).  Instead of 
writing a least privilege access policy directly in terms of API actions like `kms:Decrypt`, you declare
who should be able to `read-data`.  This module supports the following access capabilities:

* `administer-resource`
* `read-data`
* `write-data`
* `delete-data`   

First, define who should access to the key as lists of [AWS principal IDs](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_elements_principal.html).  
The most common principals you will use are AWS IAM user and role ARNs such as `arn:aws:iam::12345678910:role/appA`.  
Consider using `locals` to help document intent, keep lists synchronized, and reduce duplication.   
 
```hcl-terraform
# Define which principals may access the key and what capabilities they should have
# k9 access capabilities are defined at https://k9security.io/docs/k9-access-capability-model/  
locals {
  administrator_arns = [
    "arn:aws:iam::12345678910:user/ci"
    , "arn:aws:iam::12345678910:user/person1"
  ]

  read_data_arns = [
    "arn:aws:iam::12345678910:user/person1",
    "arn:aws:iam::12345678910:role/appA",
  ]

  write_data_arns = "${local.read_data_arns}"
}
```

Now instantiate the module with a definition like this:
```hcl-terraform
module "encryption_key" {
  source = "git@github.com:k9securityio/tf_aws_kms_key.git"
  
  # the logical name for the use case, e.g. docs, reports, media, backups 
  logical_name = "docs"
  # the region to create the key in
  region       = "us-east-1"

  org   = "someorg"
  owner = "someowner"
  env   = "dev"
  app   = "someapi"

  allow_administer_resource_arns = "${local.administrator_arns}"
  allow_read_data_arns           = "${local.read_data_arns}"
  allow_write_data_arns          = "${local.write_data_arns}"
}
```

This code enables the following access:

* allow `ci` and `person1` users to administer the key
* allow `person1` user and `appA` role to read and write data from the key
* deny all other access; this is the tricky bit!

You can see the policy this configuration generates in 
[examples/generated.least_privilege_policy.json](examples/generated.least_privilege_policy.json).

This module supports the full tagging model described in the k9 Security 
[tagging guide](https://k9security.io/docs/guide-to-tagging-cloud-deployments/).  This tagging model covers resource: 

* Identity and Ownership 
* Security
* Risk
 
Most of the tagging model is exposed as optional attributes so that you can adopt it incrementally.  See the 
([KMS key API](interface.md)) for the full set of options.  

We hope that module instantiation is easy to understand and conveys intent.  If you think this can be improved,
we would love your feedback as a pull request with a question, clarification, or alternative.

### Use KMS key module with your own policy

Alternatively, you can create your own KMS key resource policy and provide it to the module using the `policy` attribute.   

### Use the `k9policy` submodule directly 

You can also generate a least privilege resource policy using the `k9policy` submodule directly ([k9policy API](k9policy/interface.md)).  
This enables you to use a k9 key resource policy with another Terraform module. 

Instantiate the `k9policy` module directly like this:

```hcl-terraform
module "least_privilege_key_resource_policy" {
  source        = "git@github.com:k9securityio/tf_aws_kms_key.git//k9policy"
  kms_key_arn = "${module.encryption_key.key_arn}"

  allow_administer_resource_arns = "${local.administrator_arns}"
  allow_read_data_arns           = "${local.read_data_arns}"
  allow_write_data_arns          = "${local.write_data_arns}"
}
```

### Examples

See the 'minimal' test fixture at [test/fixtures/minimal/minimal.tf](test/fixtures/minimal/minimal.tf) for complete 
examples of how to use these KMS key and policy modules.

### Migrating to this module

There are at least two ways to migrate to this module:

1. if you are already using Terraform and want to try out a better key resource policy, you can use the policy submodule directly. This is described above and demonstrated in the [tests](test/fixtures/minimal/minimal.tf).
2. if you want to migrate an existing key into this Terraform module, you can use `terraform import` or `terraform mv` to migrate the AWS key resource into a new Terraform module definition.  

If you have questions or would like help, feel free to file a PR or [contact us](https://k9security.io/contact/) privately.

## Local Development and Testing

Testing modules locally can be accomplished using a series of `Make` tasks
contained in this repo.

| Make Task | What happens                                                                                                  |
|:----------|:--------------------------------------------------------------------------------------------------------------|
| all       | Execute the canonical build for the generic infrastructure module (does not destroy infra)                    |
| converge  | Execute `kitchen converge` for all modules                                                                    |
| circleci-build  | Run a local circleci build                                                                              |
| lint      | Execute `tflint` for generic infrastructure module                                                            |
| test      | Execute `kitchen test --destroy=always` for all modules                                                       |
| verify    | Execute `kitchen verify` for all modules                                                                      |
| destroy   | Execute `kitchen destroy` for all modules                                                                     |
| kitchen   | Execute `kitchen <command>`. Specify the command with the `COMMAND` argument to `make`                        |

e.g. run a single test: `make kitchen COMMAND="verify minimal-aws"`

**Typical Workflow:**

1. Start-off with a clean slate of running test infrastructure: `make destroy; make all`
2. Make changes and (repeatedly) run: `make converge && make verify`
3. Rebuild everything from scratch: `make destroy; make all`
4. Commit and issue pull request


## Running Test Kitchen for a single module

Test Kitchen uses the concept of "instances" as it's medium for multiple test 
packages in a project.
An "instance" is the combination of a _test suite_ and a _platform_.
This project uses a single _platform_ for all specs (e.g. `aws`).
The name of this platform actually doesn't matter since the terraform provisioner
and driver are not affected by it.

You can see the available test instances by running the `kitchen list` command:

```bash
$ make kitchen COMMAND=list
Instance     Driver     Provisioner  Verifier   Transport  Last Action  Last Error
default-aws  Terraform  Terraform    Terraform  Ssh        Verified
```

To run Test Kitchen processes for a single instance, you **must** use the `kitchen`
target from the make file and pass the command and the instance name using the
`COMMAND` variable to make.

```bash
# where 'default-aws is an Instance name from kitchen's list
$ make kitchen COMMAND="converge default-aws"
```