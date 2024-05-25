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
  source              = "git::https://github.com/redopsbay/cloudcycle.git//terraform?ref=master"
  lambda_iam_role_arn = aws_iam_role.cloudcycle_iam_role.arn
}
