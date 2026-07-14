############################################
# Karpenter Interruption Queue
############################################

resource "aws_sqs_queue" "karpenter" {

  name = "${local.prefix}-karpenter"

  message_retention_seconds = 300

  sqs_managed_sse_enabled = true

  tags = merge(
    local.common_tags,
    {
      Name = "${local.prefix}-karpenter"
    }
  )
}

############################################
# Allow EventBridge to send messages
############################################

data "aws_iam_policy_document" "karpenter_queue" {

  statement {

    sid = "AllowEventBridge"

    effect = "Allow"

    principals {
      type = "Service"
      identifiers = [
        "events.amazonaws.com"
      ]
    }

    actions = [
      "sqs:SendMessage"
    ]

    resources = [
      aws_sqs_queue.karpenter.arn
    ]
  }
}

resource "aws_sqs_queue_policy" "karpenter" {

  queue_url = aws_sqs_queue.karpenter.id

  policy = data.aws_iam_policy_document.karpenter_queue.json
}

############################################
# Spot Interruption
############################################

resource "aws_cloudwatch_event_rule" "spot_interruption" {

  name = "${local.prefix}-spot-interruption"

  event_pattern = jsonencode({
    source = ["aws.ec2"]

    detail-type = [
      "EC2 Spot Instance Interruption Warning"
    ]
  })
}

resource "aws_cloudwatch_event_target" "spot_interruption" {

  rule = aws_cloudwatch_event_rule.spot_interruption.name

  target_id = "karpenter"

  arn = aws_sqs_queue.karpenter.arn
}

############################################
# Instance Rebalance Recommendation
############################################

resource "aws_cloudwatch_event_rule" "rebalance" {

  name = "${local.prefix}-rebalance"

  event_pattern = jsonencode({

    source = ["aws.ec2"]

    detail-type = [
      "EC2 Instance Rebalance Recommendation"
    ]
  })
}

resource "aws_cloudwatch_event_target" "rebalance" {

  rule = aws_cloudwatch_event_rule.rebalance.name

  target_id = "karpenter"

  arn = aws_sqs_queue.karpenter.arn
}

############################################
# Instance State Change
############################################

resource "aws_cloudwatch_event_rule" "state_change" {

  name = "${local.prefix}-state-change"

  event_pattern = jsonencode({

    source = ["aws.ec2"]

    detail-type = [
      "EC2 Instance State-change Notification"
    ]
  })
}

resource "aws_cloudwatch_event_target" "state_change" {

  rule = aws_cloudwatch_event_rule.state_change.name

  target_id = "karpenter"

  arn = aws_sqs_queue.karpenter.arn
}

############################################
# Scheduled Change
############################################

resource "aws_cloudwatch_event_rule" "scheduled_change" {

  name = "${local.prefix}-scheduled-change"

  event_pattern = jsonencode({

    source = [
      "aws.health"
    ]

    detail-type = [
      "AWS Health Event"
    ]
  })
}

resource "aws_cloudwatch_event_target" "scheduled_change" {

  rule = aws_cloudwatch_event_rule.scheduled_change.name

  target_id = "karpenter"

  arn = aws_sqs_queue.karpenter.arn
}