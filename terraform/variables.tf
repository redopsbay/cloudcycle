/*
 * # CloudCycle Terraform Module 💡
 * Description
 * ============
 * This tf file provides required/optional variables for CloudCycle for lambda <br>
 * ***Author***: Alfred Valderrama (@redopsbay) <br>
*/

variable "lambda_name" {
  type        = string
  description = "AWS Lambda name"
  default     = "CloudCycle"
}

variable "region" {
  type        = string
  description = "Target AWS Region"
  default     = "ap-southeast-1"
}

variable "tags" {
  type        = map(any)
  description = "Resource tag"
  default     = null
}

variable "lambda_local_path" {
  type        = string
  description = "Specifies the `lambda.zip` local path"
  default     = "lambda.zip"
}

variable "lambda_iam_role_arn" {
  type        = string
  description = "Specify arn of lambda"
}

variable "release_url" {
  type        = string
  description = "Release url from github [https://github.com/redopsbay/cloudcycle](https://github.com/redopsbay/cloudcycle) `release.zip`"
  default     = "https://github.com/redopsbay/cloudcycle/releases/download/v1.0.0-alpha/release.zip"
}
