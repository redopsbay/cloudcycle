# CloudCycle Deployment

CloudCycle is a basic tool for cost savings in the cloud and it's basically a cloud native solution that requires basic deployment. Below are the prerequirites.

## Prerequisites

- [x] Terraform
- [x] AWS Cloud Account
- [x] Terraform IAM Permissions
  - [x] Lambda Permissions
  - [x] IAM Permission
  - [x] Event Bridge Permission
  - [x] CloudWatch Permission


### First, Create minimal IAM Permission for our Lambda

`policy.json`

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "logs:CreateLogGroup",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeInstances",
				"ec2:DescribeInstanceStatus",
				"ec2:DescribeNetworkInterfaces",
				"ec2:DescribeTags",
				"ec2:DeleteVolume",
				"ec2:DeleteTags",
				"ec2:TerminateInstances"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
```

### Sample Terraform Code

Below code, is the sample terraform code and commands to deploy CloudCycle via Terraform:

`main.tf`

```tcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.51.1"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

/* Deploy `eventbridge_rule` / `lambda_function` */

module "cloudcycle" {
  source              = "https://github.com/redopsbay/cloudcycle.git//terraform?ref=master"
  lambda_iam_role_arn = aws_iam_role.cloudcycle_iam_role.arn
}
```

For `iam.tf`:


```hcl
/* IAM Role Policy resource to allow cloudcycle lambda function to get/list/delete supported resources */
resource "aws_iam_role_policy" "cloudcycle_policy" {
  name = "CloudCyclePolicy"
  role = aws_iam_role.cloudcycle_iam_role.id

  policy = file("policy.json")
}

/* IAM Role for cloudcycle */

resource "aws_iam_role" "cloudcycle_iam_role" {
  name = "CloudCycleRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Function = "CloudCycle"
  }
}

```

### Deployment

Now, It's time for the terraform deployment.

```hcl
terraform init
terraform fmt
terraform validate
terraform plan -out=plan.out
terraform apply plan.out
```

Output

```bash
Initializing the backend...
Initializing modules...
Downloading git::https://github.com/redopsbay/cloudcycle.git?ref=master for cloudcycle...
- cloudcycle in .terraform/modules/cloudcycle/terraform

Initializing provider plugins...
- Finding latest version of hashicorp/null...
- Finding hashicorp/aws versions matching "5.51.1"...
- Finding hashicorp/http versions matching "~> 2.0"...
- Installing hashicorp/aws v5.51.1...
- Installed hashicorp/aws v5.51.1 (signed by HashiCorp)
- Installing hashicorp/http v2.2.0...
- Installed hashicorp/http v2.2.0 (signed by HashiCorp)
- Installing hashicorp/null v3.2.2...
- Installed hashicorp/null v3.2.2 (signed by HashiCorp)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
Success! The configuration is valid.

module.cloudcycle.data.aws_caller_identity.current: Reading...
module.cloudcycle.data.aws_caller_identity.current: Read complete after 0s [id=123456789012]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_iam_role.cloudcycle_iam_role will be created
  + resource "aws_iam_role" "cloudcycle_iam_role" {
      + arn                   = (known after apply)
      + assume_role_policy    = jsonencode(
            {
              + Statement = [
                  + {
                      + Action    = "sts:AssumeRole"
                      + Effect    = "Allow"
                      + Principal = {
                          + Service = "lambda.amazonaws.com"
                        }
                      + Sid       = ""
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + create_date           = (known after apply)
      + force_detach_policies = false
      + id                    = (known after apply)
      + managed_policy_arns   = (known after apply)
      + max_session_duration  = 3600
      + name                  = "CloudCycleRole"
      + name_prefix           = (known after apply)
      + path                  = "/"
      + tags                  = {
          + "Function" = "CloudCycle"
        }
      + tags_all              = {
          + "Function" = "CloudCycle"
        }
      + unique_id             = (known after apply)
    }

  # aws_iam_role_policy.cloudcycle_policy will be created
  + resource "aws_iam_role_policy" "cloudcycle_policy" {
      + id          = (known after apply)
      + name        = "CloudCyclePolicy"
      + name_prefix = (known after apply)
      + policy      = jsonencode(
            {
              + Statement = [
                  + {
                      + Action   = "logs:CreateLogGroup"
                      + Effect   = "Allow"
                      + Resource = "*"
                    },
                  + {
                      + Action   = [
                          + "logs:CreateLogStream",
                          + "logs:PutLogEvents",
                        ]
                      + Effect   = "Allow"
                      + Resource = [
                          + "*",
                        ]
                    },
                  + {
                      + Action   = [
                          + "ec2:DescribeInstances",
                          + "ec2:DescribeInstanceStatus",
                          + "ec2:DescribeNetworkInterfaces",
                          + "ec2:DescribeTags",
                          + "ec2:DeleteVolume",
                          + "ec2:DeleteTags",
                          + "ec2:TerminateInstances",
                        ]
                      + Effect   = "Allow"
                      + Resource = [
                          + "*",
                        ]
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + role        = (known after apply)
    }

  # module.cloudcycle.aws_cloudwatch_event_rule.cloudcycle_schedule will be created
  + resource "aws_cloudwatch_event_rule" "cloudcycle_schedule" {
      + arn                 = (known after apply)
      + description         = "CloudCycle Lambda gets trigger every 15 minutes."
      + event_bus_name      = "default"
      + force_destroy       = false
      + id                  = (known after apply)
      + name                = "CloudCycle-Event-Rule"
      + name_prefix         = (known after apply)
      + schedule_expression = "cron(0/15 * * * ? *)"
      + tags                = {
          + "Function" = "CloudCycle for Cost Savings"
        }
      + tags_all            = {
          + "Function" = "CloudCycle for Cost Savings"
        }
    }

  # module.cloudcycle.aws_cloudwatch_event_target.cloudcycle_lambda_target will be created
  + resource "aws_cloudwatch_event_target" "cloudcycle_lambda_target" {
      + arn            = (known after apply)
      + event_bus_name = "default"
      + force_destroy  = false
      + id             = (known after apply)
      + rule           = "CloudCycle-Event-Rule"
      + target_id      = "CloudCycle"
    }

  # module.cloudcycle.aws_lambda_function.cloudcycle will be created
  + resource "aws_lambda_function" "cloudcycle" {
      + architectures                  = (known after apply)
      + arn                            = (known after apply)
      + code_sha256                    = (known after apply)
      + description                    = "Lambda CloudCycle for Cost Savings"
      + filename                       = "lambda.zip"
      + function_name                  = "CloudCycle"
      + handler                        = "bootstrap"
      + id                             = (known after apply)
      + invoke_arn                     = (known after apply)
      + last_modified                  = (known after apply)
      + memory_size                    = 128
      + package_type                   = "Zip"
      + publish                        = true
      + qualified_arn                  = (known after apply)
      + qualified_invoke_arn           = (known after apply)
      + reserved_concurrent_executions = -1
      + role                           = (known after apply)
      + runtime                        = "provided.al2023"
      + signing_job_arn                = (known after apply)
      + signing_profile_version_arn    = (known after apply)
      + skip_destroy                   = false
      + source_code_hash               = (known after apply)
      + source_code_size               = (known after apply)
      + tags                           = {
          + "Function" = "CloudCycle for Cost Savings"
        }
      + tags_all                       = {
          + "Function" = "CloudCycle for Cost Savings"
        }
      + timeout                        = 3
      + version                        = (known after apply)
    }

  # module.cloudcycle.aws_lambda_permission.allow_event_bridge will be created
  + resource "aws_lambda_permission" "allow_event_bridge" {
      + action              = "lambda:InvokeFunction"
      + function_name       = "CloudCycle"
      + id                  = (known after apply)
      + principal           = "events.amazonaws.com"
      + source_arn          = (known after apply)
      + statement_id        = "AllowExecutionFromEventBridge"
      + statement_id_prefix = (known after apply)
    }

  # module.cloudcycle.null_resource.lambda_file will be created
  + resource "null_resource" "lambda_file" {
      + id = (known after apply)
    }

Plan: 7 to add, 0 to change, 0 to destroy.
```
