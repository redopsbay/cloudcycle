/*
 * # CloudCycle Terraform Module 💡
 * Description
 * ============
 * This tf file provides the main logic for CloudCycle for this tf module <br>
 * ***Author***: Alfred Valderrama (@redopsbay) <br>
*/

provider "http" {}
data "aws_caller_identity" "current" {}
data "http" "lambda_zip" {
  url = "TODO"
}

resource "local_file" "lambda_file" {
  content  = data.http.lambda_zip.body
  filename = var.lambda_local_path
}

module "lambda_cloudcycle" {
  source        = "terraform-aws-modules/lambda/aws"
  version       = "7.4.0"
  function_name = var.lambda_name
  description   = "CloudCycle for cost savings"
  handler       = "bootstrap"
  runtime       = "provided.al2023"
  publish       = true
  source_path   = var.lambda_local_path
  //role          = ""

  tags = merge(var.tags, {
    Name        = "CloudCycle"
    Description = "CloudCycle for cost savings"
  })
}


module "eventbridge" {
  source     = "terraform-aws-modules/eventbridge/aws"
  version    = "3.3.1"
  create_bus = false

  rules = {
    crons = {
      description         = "Run the event bridge every 15 minutes"
      schedule_expression = "cron(*/15 * * ? *)"
    }
  }

  targets = {
    crons = [
      {
        name  = "cloudcycle"
        arn   = module.lambda_cloudcycle.lambda_function_arn
        input = jsonencode({ "useless" : "input" })
      }
    ]
  }
}
