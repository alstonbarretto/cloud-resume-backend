resource "aws_apigatewayv2_api" "this" {
  name          = "resume-counter-api"
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins = [var.allowed_origin]
    allow_methods = ["GET", "OPTIONS"]
    allow_headers = ["content-type"]
  }
}

resource "aws_apigatewayv2_stage" "prod" {
  api_id      = aws_apigatewayv2_api.this.id
  name        = "prod"
  auto_deploy = true
}

resource "aws_apigatewayv2_integration" "lambda" {
  api_id           = aws_apigatewayv2_api.this.id
  integration_type = "AWS_PROXY"
  integration_uri  = var.lambda_arn
}

resource "aws_apigatewayv2_route" "count" {
  api_id    = aws_apigatewayv2_api.this.id
  route_key = "GET /count"
  target    = "integrations/${aws_apigatewayv2_integration.lambda.id}"
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.this.execution_arn}/*/*"
}

output "api_endpoint" {
  value = aws_apigatewayv2_api.this.api_endpoint
}

variable "lambda_arn" {}
variable "lambda_name" {}
variable "allowed_origin" {}