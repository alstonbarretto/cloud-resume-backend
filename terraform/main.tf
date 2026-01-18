module "dynamodb" {
  source     = "./modules/dynamodb"
  table_name = var.table_name
}

module "iam" {
  source    = "./modules/iam"
  table_arn = module.dynamodb.table_arn
}

module "lambda" {
  source      = "./modules/lambda"
  lambda_name = var.lambda_name
  table_name  = var.table_name
  role_arn    = module.iam.lambda_role_arn
}

module "api_gateway" {
  source         = "./modules/api_gateway"
  lambda_arn     = module.lambda.lambda_arn
  lambda_name    = var.lambda_name
  allowed_origin = var.allowed_origin
}