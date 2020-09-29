## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_tags | A map of additional tags to merge with the module's standard tags and apply to the key. | `map(string)` | `{}` | no |
| allow\_administer\_resource\_arns | The list of fully-qualified AWS IAM ARNs authorized to administer this key. Wildcards are supported. e.g. arn:aws:iam::12345678910:user/ci or arn:aws:iam::12345678910:role/app-backend-\* | `list(string)` | `[]` | no |
| allow\_administer\_resource\_test | The IAM test to use in the policy statement condition, should be one of 'ArnEquals' (default) or 'ArnLike' | `string` | `"ArnEquals"` | no |
| allow\_delete\_data\_arns | The list of fully-qualified AWS IAM ARNs authorized to delete data protected by this key. Wildcards are supported. e.g. arn:aws:iam::12345678910:user/ci or arn:aws:iam::12345678910:role/app-backend-\* | `list(string)` | `[]` | no |
| allow\_delete\_data\_test | The IAM test to use in the policy statement condition, should be one of 'ArnEquals' (default) or 'ArnLike' | `string` | `"ArnEquals"` | no |
| allow\_read\_data\_arns | The list of fully-qualified AWS IAM ARNs authorized to read data protected by this key. Wildcards are supported. e.g. arn:aws:iam::12345678910:user/ci or arn:aws:iam::12345678910:role/app-backend-\* | `list(string)` | `[]` | no |
| allow\_read\_data\_test | The IAM test to use in the policy statement condition, should be one of 'ArnEquals' (default) or 'ArnLike' | `string` | `"ArnEquals"` | no |
| allow\_write\_data\_arns | The list of fully-qualified AWS IAM ARNs authorized to write data protected by this key. Wildcards are supported. e.g. arn:aws:iam::12345678910:user/ci or arn:aws:iam::12345678910:role/app-backend-\* | `list(string)` | `[]` | no |
| allow\_write\_data\_test | The IAM test to use in the policy statement condition, should be one of 'ArnEquals' (default) or 'ArnLike' | `string` | `"ArnEquals"` | no |
| app | Name of the application the key supports | `string` | n/a | yes |
| availability | Expected Availability level of data protected by the key, e.g. 0.999, 0.9999, 0.99999, 0.999999 | `string` | `""` | no |
| business\_process | The high-level business process the key supports | `string` | `""` | no |
| business\_unit | The top-level organizational division that owns the resource. e.g. Consumer Retail, Enterprise Solutions, Manufacturing | `string` | `""` | no |
| compliance\_scheme | The regulatory compliance scheme the resource’s configuration should conform to | `string` | `""` | no |
| confidentiality | Expected Confidentiality level of data protected by the key, e.g. Public, Internal, Confidential, Restricted | `string` | `""` | no |
| cost\_center | The managerial accounting cost center for the key | `string` | `""` | no |
| customer\_master\_key\_spec | (optional) specifies whether the key contains a symmetric key or an asymmetric key pair and the encryption algorithms or signing algorithms that the key supports; defaults to SYMMETRIC\_DEFAULT | `string` | `"SYMMETRIC_DEFAULT"` | no |
| deletion\_window\_in\_days | (optional) the length of the pending deletion window in days; | `string` | `"30"` | no |
| enable\_key\_rotation | (optional) enable annual key rotation by AWS | `bool` | `true` | no |
| enabled | (optional) whether the key is enabled for use or not | `bool` | `true` | no |
| env | Name of the environment the key supports | `string` | n/a | yes |
| integrity | Expected Integrity level of data protected by the key, e.g. 0.999, 0.9999, 0.99999, 0.999999 | `string` | `""` | no |
| key\_usage | (optional) specifies the intended use of the key; defaults to ENCRYPT\_DECRYPT | `string` | `"ENCRYPT_DECRYPT"` | no |
| logical\_name | Specify the 'logical' name of the key appropriate for the key's primary use case, e.g. media or orders | `string` | n/a | yes |
| org | Short id of the organization that owns the key | `string` | n/a | yes |
| owner | Name of the team or department that responsible for the key | `string` | n/a | yes |
| policy | (optional) fully rendered policy; if unspecified, the policy will be generated from the `allow_*` variables | `string` | `""` | no |
| region | The region to instantiate the key in | `string` | n/a | yes |
| role | The role or function of this resource within the Application's logical architecture, e.g. load balancer, app server, database | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| key\_alias | n/a |
| key\_arn | n/a |
| key\_id | n/a |
| policy\_json | n/a |

