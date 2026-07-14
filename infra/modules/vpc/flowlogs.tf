#CloudWatch Log Group

resource "aws_cloudwatch_log_group" "flowlogs" {

  name = "/aws/vpc/${local.name}"

  retention_in_days = 30

}


#IAM Role
resource "aws_iam_role" "flowlogs" {

  name = "${local.name}-flowlogs"

  assume_role_policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {

        Action = "sts:AssumeRole"

        Effect = "Allow"

        Principal = {

          Service = "vpc-flow-logs.amazonaws.com"

        }

      }

    ]

  })

}


#IAM Policy
resource "aws_iam_role_policy" "flowlogs" {

  role = aws_iam_role.flowlogs.id

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {

        Effect = "Allow"

        Action = [

          "logs:CreateLogStream",

          "logs:PutLogEvents"

        ]

        Resource = "*"

      }

    ]

  })

}


#Enable Flow Logs

resource "aws_flow_log" "this" {

  iam_role_arn = aws_iam_role.flowlogs.arn

  log_destination = aws_cloudwatch_log_group.flowlogs.arn

  traffic_type = "ALL"

  vpc_id = module.vpc.vpc_id

}