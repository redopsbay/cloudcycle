/*
 * # CloudCycle Terraform Module 💡
 * Description
 * ============
 * This tf file provides the main logic for CloudCycle for this tf module <br>
 * ***Author***: Alfred Valderrama (@redopsbay) <br>
*/

data "aws_caller_identity" "current" {}


/* Download the release file */
resource "null_resource" "lambda_file" {
  provisioner "local-exec" {
    command = "curl -Lo lambda.zip ${var.release_url}"
  }
}


/* Lambda Function */

resource "aws_lambda_function" "cloudcycle" {
  filename      = var.lambda_local_path
  function_name = var.lambda_name
  role          = var.lambda_iam_role_arn
  handler       = "bootstrap"
  description   = "Lambda CloudCycle for Cost Savings"
  publish       = true


  runtime = "provided.al2023"

  tags = var.tags != null ? merge(var.tags, {
    Function        = "CloudCycle for Cost Savings"
    }) : { Function = "CloudCycle for Cost Savings"
  }
  depends_on = [null_resource.lambda_file]
}

/* Event Bridge Rule that run's every 15 minute window */

resource "aws_cloudwatch_event_rule" "cloudcycle_schedule" {
  name        = "CloudCycle-Event-Rule"
  description = "CloudCycle Lambda gets trigger every 15 minutes."

  schedule_expression = "cron(0/15 * * * ? *)"
  depends_on          = [aws_lambda_function.cloudcycle]
  tags = var.tags != null ? merge(var.tags, {
    Function        = "CloudCycle for Cost Savings"
    }) : { Function = "CloudCycle for Cost Savings"
  }
}

/* Set event bridge rule target */

resource "aws_cloudwatch_event_target" "cloudcycle_lambda_target" {
  rule      = aws_cloudwatch_event_rule.cloudcycle_schedule.name
  target_id = var.lambda_name
  arn       = aws_lambda_function.cloudcycle.arn
  depends_on = [
    aws_lambda_function.cloudcycle,
    aws_cloudwatch_event_rule.cloudcycle_schedule
  ]
}

/* Allow event bridge to trigger lambda function */

resource "aws_lambda_permission" "allow_event_bridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.cloudcycle.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.cloudcycle_schedule.arn
}
