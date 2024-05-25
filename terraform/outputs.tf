/*
 * # CloudCycle Terraform Module 💡
 * Description
 * ============
 * This tf file provides the outputs for CloudCycle for this tf module <br>
 * ***Author***: Alfred Valderrama (@redopsbay) <br>
*/

output "cloudcycle_lambda_function_invoke_arn" {
  value       = aws_lambda_function.cloudcycle.invoke_arn
  description = "cloudcycle lambda invoke arn"
}

output "cloudcycle_lambda_arn" {
  value       = aws_lambda_function.cloudcycle.arn
  description = "cloudcycle lambda role arn"
}

output "cloudcycle_lambda_tags_all" {
  value       = aws_lambda_function.cloudcycle.tags_all
  description = "cloudcycle lambda tags"
}

output "cloudcycle_event_rule_id" {
  value       = aws_cloudwatch_event_rule.cloudcycle_schedule.id
  description = "id of event bridge rule"
}

output "cloudcycle_event_rule_arn" {
  value       = aws_cloudwatch_event_rule.cloudcycle_schedule.arn
  description = "arn of cloudwatch event bridge rule"
}

output "cloudcycle_event_rule_tags" {
  value       = aws_cloudwatch_event_rule.cloudcycle_schedule.tags_all
  description = "tags of cloudwatch event bridge rule"
}

output "cloudcycle_release" {
  value       = var.release_url
  description = "show release url"
}
