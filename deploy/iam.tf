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
