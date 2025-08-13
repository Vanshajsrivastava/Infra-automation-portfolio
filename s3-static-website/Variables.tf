variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-2"
}

variable "bucket_name" {
  description = "Globally-unique S3 bucket name"
  type        = string
}

variable "index_document" {
  description = "Website index document"
  type        = string
  default     = "index.html"
}

variable "error_document" {
  description = "Website error document"
  type        = string
  default     = "error.html"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    Project = "S3-Static-Website"
    Managed = "Terraform"
  }
}
