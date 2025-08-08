output "vpc_id" {
  description = "Monitoring VPC ID"
  value       = aws_vpc.mon.id
}

output "subnet_id" {
  description = "Public subnet ID"
  value       = aws_subnet.mon_public.id
}

output "instance_id" {
  description = "Demo instance ID"
  value       = aws_instance.monitor_demo.id
}

output "sns_topic_arn" {
  description = "SNS topic ARN"
  value       = aws_sns_topic.alerts.arn
}

output "alarm_name" {
  description = "CPU alarm name"
  value       = aws_cloudwatch_metric_alarm.cpu_high.alarm_name
}

output "dashboard_name" {
  description = "CloudWatch dashboard name"
  value       = aws_cloudwatch_dashboard.ec2_dash.dashboard_name
}
