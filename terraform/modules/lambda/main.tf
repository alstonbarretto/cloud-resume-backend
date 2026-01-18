# terraform/modules/lambda/main.tf

variable "lambda_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "table_name" {
  description = "DynamoDB table name"
  type        = string
}

variable "role_arn" {
  description = "IAM role ARN for Lambda"
  type        = string
}

# Lambda function
resource "aws_lambda_function" "main" {
  filename         = "${path.root}/lambda.zip"  # ✅ Points to root/lambda.zip
  function_name    = var.lambda_name
  role            = var.role_arn
  handler         = "lambda.lambda_handler"
  source_code_hash = filebase64sha256("${path.root}/lambda.zip")
  runtime         = "python3.11"
  timeout         = 10
  memory_size     = 128

  environment {
    variables = {
      resumeVisitors = var.table_name
    }
  }

  tags = {
    Name        = var.lambda_name
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}

# Lambda permission for API Gateway
resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.main.function_name
  principal     = "apigateway.amazonaws.com"
}

# Outputs
output "lambda_arn" {
  value       = aws_lambda_function.main.arn
  description = "ARN of the Lambda function"
}

output "lambda_function_name" {
  value       = aws_lambda_function.main.function_name
  description = "Name of the Lambda function"
}

output "lambda_invoke_arn" {
  value       = aws_lambda_function.main.invoke_arn
  description = "Invoke ARN of the Lambda function"
}