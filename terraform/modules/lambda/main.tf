data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = "${path.module}/lambda.zip"

  source {
    content  = file("${path.module}/lambda.py")
    filename = "lambda.py"
  }
}

resource "aws_lambda_function" "this" {
  function_name = var.lambda_name
  runtime       = "python3.11"
  handler       = "lambda.lambda_handler"
  role          = var.role_arn
  timeout       = 3

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = {
      resumeVisitors = var.table_name
    }
  }
}

variable "lambda_name" {}
variable "table_name" {}
variable "role_arn" {}

output "lambda_arn" {
  value = aws_lambda_function.this.arn
}