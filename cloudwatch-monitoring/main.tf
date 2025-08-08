#############################
# Minimal networking (VPC)
#############################

resource "aws_vpc" "mon" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = { Name = "cw-mon-vpc" }
}

resource "aws_subnet" "mon_public" {
  vpc_id                  = aws_vpc.mon.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = { Name = "cw-mon-public-subnet" }
}

resource "aws_internet_gateway" "mon" {
  vpc_id = aws_vpc.mon.id
  tags   = { Name = "cw-mon-igw" }
}

resource "aws_route_table" "mon_public" {
  vpc_id = aws_vpc.mon.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mon.id
  }
  tags = { Name = "cw-mon-public-rt" }
}

resource "aws_route_table_association" "mon_public" {
  subnet_id      = aws_subnet.mon_public.id
  route_table_id = aws_route_table.mon_public.id
}

resource "aws_security_group" "mon" {
  name        = "cw-mon-sg"
  description = "Allow all egress; (SSH optional)"
  vpc_id      = aws_vpc.mon.id

  # Optional SSH from your IP address (uncomment & replace YOUR.IP.HERE/32)
  # ingress {
  #   from_port   = 22
  #   to_port     = 22
  #   protocol    = "tcp"
  #   cidr_blocks = ["YOUR.IP.HERE/32"]
  # }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "cw-mon-sg" }
}

#############################
# EC2 demo instance
#############################

# Latest Amazon Linux 2 AMI
data "aws_ami" "al2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "monitor_demo" {
  ami                         = data.aws_ami.al2.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.mon_public.id
  vpc_security_group_ids      = [aws_security_group.mon.id]
  associate_public_ip_address = true

  # Generate CPU load (~10 minutes)
  user_data = <<-EOF
    #!/bin/bash
    for i in 1 2; do
      (timeout 600 sh -c 'yes > /dev/null') &
    done
  EOF

  tags = { Name = "cloudwatch-monitoring-demo" }
}

#############################
# SNS (topic + email)
#############################

resource "aws_sns_topic" "alerts" {
  name = "cloudwatch-alarms-topic"
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alarm_email
}

#############################
# CloudWatch Alarm (CPU)
#############################

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "EC2-High-CPU-${aws_instance.monitor_demo.id}"
  alarm_description   = "CPU > ${var.cpu_threshold}% for ${var.evaluation_periods} minutes"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  statistic           = "Average"
  period              = 60
  evaluation_periods  = var.evaluation_periods
  threshold           = var.cpu_threshold
  comparison_operator = "GreaterThanThreshold"
  treat_missing_data  = "notBreaching"

  dimensions = {
    InstanceId = aws_instance.monitor_demo.id
  }

  alarm_actions = [aws_sns_topic.alerts.arn]
  ok_actions    = [aws_sns_topic.alerts.arn]
}

#############################
# Optional: Dashboard
#############################

resource "aws_cloudwatch_dashboard" "ec2_dash" {
  dashboard_name = "EC2-Monitoring-${aws_instance.monitor_demo.id}"
  dashboard_body = jsonencode({
    widgets = [
      {
        "type": "metric", "x": 0, "y": 0, "width": 12, "height": 6,
        "properties": {
          "metrics": [
            [ "AWS/EC2", "CPUUtilization", "InstanceId", aws_instance.monitor_demo.id ]
          ],
          "period": 60, "stat": "Average",
          "region": var.aws_region, "title": "CPU Utilization"
        }
      },
      {
        "type": "metric", "x": 0, "y": 6, "width": 12, "height": 6,
        "properties": {
          "metrics": [
            [ "AWS/EC2", "NetworkIn", "InstanceId", aws_instance.monitor_demo.id ],
            [ "AWS/EC2", "NetworkOut", "InstanceId", aws_instance.monitor_demo.id ]
          ],
          "period": 60, "stat": "Sum",
          "region": var.aws_region, "title": "Network In/Out"
        }
      }
    ]
  })
}
