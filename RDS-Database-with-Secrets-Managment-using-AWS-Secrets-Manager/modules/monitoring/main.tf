resource "aws_sns_topic" "rds_alerts" {

  name = "rds-alerts"

  tags = {
    Name = "rds-project/rds-sns-alerts"
  }
}

resource "aws_sns_topic_subscription" "email" {

  topic_arn = aws_sns_topic.rds_alerts.arn

  protocol = "email"

  endpoint = var.notification_email
}

resource "aws_cloudwatch_metric_alarm" "high_cpu" {

  alarm_name = "rds-high-cpu"

  comparison_operator = "GreaterThanThreshold"

  evaluation_periods = 2

  metric_name = "CPUUtilization"

  namespace = "AWS/RDS"

  period = 300

  statistic = "Average"

  threshold = 50

  alarm_description = "RDS CPU utilization above 80%"

  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }

  alarm_actions = [
    aws_sns_topic.rds_alerts.arn
  ]

  ok_actions = [
    aws_sns_topic.rds_alerts.arn
  ]
}

resource "aws_cloudwatch_metric_alarm" "low_storage" {

  alarm_name = "rds-low-storage"

  comparison_operator = "LessThanThreshold"

  evaluation_periods = 1

  metric_name = "FreeStorageSpace"

  namespace = "AWS/RDS"

  period = 300

  statistic = "Average"

  threshold = 2000000000

  alarm_description = "RDS free storage below 2GB"

  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }

  alarm_actions = [
    aws_sns_topic.rds_alerts.arn
  ]

  ok_actions = [
    aws_sns_topic.rds_alerts.arn
  ]
}