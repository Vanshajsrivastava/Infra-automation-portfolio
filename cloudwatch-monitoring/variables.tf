variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "eu-west-2"
}

variable "alarm_email" {
  type        = string
  description = "Email to receive CloudWatch alarm notifications"
}

variable "cpu_threshold" {
  type        = number
  description = "CPU Utilization threshold (%)"
  default     = 80
}

variable "evaluation_periods" {
  type        = number
  description = "Number of 1-minute periods above threshold to trigger alarm"
  default     = 5
}
