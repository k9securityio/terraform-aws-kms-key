
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| additional_tags | A map of additional tags to merge with the module's standard tags and apply to the key. | map | `<map>` | no |
| allow_administer_resource_arns | The list of fully-qualified AWS IAM ARNs authorized to administer this key. Wildcards are supported. e.g. arn:aws:iam::12345678910:user/ci or arn:aws:iam::12345678910:role/app-backend-* | list | `<list>` | no |
| allow_administer_resource_test | The IAM test to use in the policy statement condition, should be one of 'ArnEquals' (default) or 'ArnLike' | string | `ArnEquals` | no |
| allow_delete_data_arns | The list of fully-qualified AWS IAM ARNs authorized to delete data protected by this key. Wildcards are supported. e.g. arn:aws:iam::12345678910:user/ci or arn:aws:iam::12345678910:role/app-backend-* | list | `<list>` | no |
| allow_delete_data_test | The IAM test to use in the policy statement condition, should be one of 'ArnEquals' (default) or 'ArnLike' | string | `ArnEquals` | no |
| allow_read_data_arns | The list of fully-qualified AWS IAM ARNs authorized to read data protected by this key. Wildcards are supported. e.g. arn:aws:iam::12345678910:user/ci or arn:aws:iam::12345678910:role/app-backend-* | list | `<list>` | no |
| allow_read_data_test | The IAM test to use in the policy statement condition, should be one of 'ArnEquals' (default) or 'ArnLike' | string | `ArnEquals` | no |
| allow_write_data_arns | The list of fully-qualified AWS IAM ARNs authorized to write data protected by this key. Wildcards are supported. e.g. arn:aws:iam::12345678910:user/ci or arn:aws:iam::12345678910:role/app-backend-* | list | `<list>` | no |
| allow_write_data_test | The IAM test to use in the policy statement condition, should be one of 'ArnEquals' (default) or 'ArnLike' | string | `ArnEquals` | no |
| app | Name of the application the key supports | string | - | yes |
| availability | Expected Availability level of data protected by the key, e.g. 0.999, 0.9999, 0.99999, 0.999999 | string | `` | no |
| business_process | The high-level business process the key supports | string | `` | no |
| business_unit | The top-level organizational division that owns the resource. e.g. Consumer Retail, Enterprise Solutions, Manufacturing | string | `` | no |
| compliance_scheme | The regulatory compliance scheme the resource’s configuration should conform to | string | `` | no |
| confidentiality | Expected Confidentiality level of data protected by the key, e.g. Public, Internal, Confidential, Restricted | string | `` | no |
| cost_center | The managerial accounting cost center for the key | string | `` | no |
| deletion_window_in_days | (optional) the length of the pending deletion window in days; | string | `30` | no |
| enable_key_rotation | (optional) enable annual key rotation by AWS | string | `true` | no |
| enabled | (optional) whether the key is enabled for use or not | string | `true` | no |
| env | Name of the environment the key supports | string | - | yes |
| integrity | Expected Integrity level of data protected by the key, e.g. 0.999, 0.9999, 0.99999, 0.999999 | string | `` | no |
| logical_name | Specify the 'logical' name of the key appropriate for the key's primary use case, e.g. media or orders | string | - | yes |
| org | Short id of the organization that owns the key | string | - | yes |
| owner | Name of the team or department that responsible for the key | string | - | yes |
| policy | (optional) fully rendered policy; if unspecified, the policy will be generated from the `allow_*` variables | string | `` | no |
| region | The region to instantiate the key in | string | - | yes |
| role | The role or function of this resource within the Application's logical architecture, e.g. load balancer, app server, database | string | `` | no |

## Outputs

| Name | Description |
|------|-------------|
| key_alias |  |
| key_arn |  |
| key_id |  |
| policy_json |  |

