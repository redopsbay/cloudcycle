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
}

variable "lambda_local_path" {
  type        = string
  description = "Specifies the `lambda.zip` local path"
  default     = "/tmp/lambda.zip"
}
