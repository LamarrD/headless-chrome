terraform {
  required_version = ">= 1.2.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  backend "s3" {}
}

provider "aws" {
  region              = "us-east-1"
}

resource "aws_s3_bucket" "lambda_layer_bucket" {
  bucket = "lambda-layers-${var.account_id}"
}

resource "aws_s3_object" "lambda_layer_object" {
  bucket = aws_s3_bucket.lambda_layer_bucket.bucket
  key    = "layer-headless_chrome.zip"
  source = "layer-headless_chrome.zip"
}

resource "aws_lambda_layer_version" "lambda_layer" {
  layer_name          = "headless-chrome"
  s3_bucket           = aws_s3_bucket.lambda_layer_bucket.bucket
  s3_key              = "layer-headless_chrome.zip"
  compatible_runtimes = ["python3.8", "python3.9", "python3.10"]
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda-role"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{ Effect = "Allow", Principal = { Service = "lambda.amazonaws.com" }, Action = "sts:AssumeRole" }]
  })
}

resource "aws_lambda_function" "test_lambda" {
  function_name    = "test_lambda"
  timeout          = 30
  memory_size      = 256
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.8"
  filename         = "lambda_function.zip"
  source_code_hash = filebase64sha256("lambda_function.zip")
  layers           = [aws_lambda_layer_version.lambda_layer.arn]
}
