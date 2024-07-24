variable "account_id" {
  description = "Account ID for layers S3 bucket"
  type        = string
}

variable "bucket" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "key" {
  description = "The key for the state file in S3"
  type        = string
}

variable "region" {
  description = "The AWS region of the S3 bucket"
  type        = string
}