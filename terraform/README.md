<!-- BEGIN_TF_DOCS -->
# CloudCycle Terraform Module 💡
Description
============
This tf file provides the main logic for CloudCycle for this tf module <br>
***Author***: Alfred Valderrama (@redopsbay) <br>

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_http"></a> [http](#requirement\_http) | ~> 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.51.0 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.cloudcycle_schedule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.cloudcycle_lambda_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_lambda_function.cloudcycle](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.allow_event_bridge](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [null_resource.lambda_file](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_lambda_iam_role_arn"></a> [lambda\_iam\_role\_arn](#input\_lambda\_iam\_role\_arn) | Specify arn of lambda | `string` | n/a | yes |
| <a name="input_lambda_local_path"></a> [lambda\_local\_path](#input\_lambda\_local\_path) | Specifies the `lambda.zip` local path | `string` | `"lambda.zip"` | no |
| <a name="input_lambda_name"></a> [lambda\_name](#input\_lambda\_name) | AWS Lambda name | `string` | `"CloudCycle"` | no |
| <a name="input_region"></a> [region](#input\_region) | Target AWS Region | `string` | `"ap-southeast-1"` | no |
| <a name="input_release_url"></a> [release\_url](#input\_release\_url) | Release url from github [https://github.com/redopsbay/cloudcycle](https://github.com/redopsbay/cloudcycle) `release.zip` | `string` | `"https://github.com/redopsbay/cloudcycle/releases/download/v1.0.0-alpha/release.zip"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource tag | `map(any)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudcycle_event_rule_arn"></a> [cloudcycle\_event\_rule\_arn](#output\_cloudcycle\_event\_rule\_arn) | arn of cloudwatch event bridge rule |
| <a name="output_cloudcycle_event_rule_id"></a> [cloudcycle\_event\_rule\_id](#output\_cloudcycle\_event\_rule\_id) | id of event bridge rule |
| <a name="output_cloudcycle_event_rule_tags"></a> [cloudcycle\_event\_rule\_tags](#output\_cloudcycle\_event\_rule\_tags) | tags of cloudwatch event bridge rule |
| <a name="output_cloudcycle_lambda_arn"></a> [cloudcycle\_lambda\_arn](#output\_cloudcycle\_lambda\_arn) | cloudcycle lambda role arn |
| <a name="output_cloudcycle_lambda_function_invoke_arn"></a> [cloudcycle\_lambda\_function\_invoke\_arn](#output\_cloudcycle\_lambda\_function\_invoke\_arn) | cloudcycle lambda invoke arn |
| <a name="output_cloudcycle_lambda_tags_all"></a> [cloudcycle\_lambda\_tags\_all](#output\_cloudcycle\_lambda\_tags\_all) | cloudcycle lambda tags |
| <a name="output_cloudcycle_release"></a> [cloudcycle\_release](#output\_cloudcycle\_release) | show release url |
<!-- END_TF_DOCS -->
