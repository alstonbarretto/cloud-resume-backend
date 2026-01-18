# terraform/variables.tf
# Terraform Variables for Cloud Resume Backend

variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "eu-west-2"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]{1}$", var.aws_region))
    error_message = "AWS region must be a valid region format (e.g., eu-west-2, us-east-1)."
  }
}

variable "table_name" {
  description = "Name of the DynamoDB table for visitor counter"
  type        = string
  default     = "resumeVisitors"

  validation {
    condition     = length(var.table_name) >= 3 && length(var.table_name) <= 255
    error_message = "Table name must be between 3 and 255 characters."
  }
}

variable "lambda_name" {
  description = "Name of the Lambda function for visitor counter"
  type        = string
  default     = "resume-visitor-counter"

  validation {
    condition     = length(var.lambda_name) >= 1 && length(var.lambda_name) <= 64
    error_message = "Lambda function name must be between 1 and 64 characters."
  }
}

variable "allowed_origin" {
  description = "CORS allowed origin for API Gateway (your website URL)"
  type        = string
  default     = "https://alstontech.uk"

  validation {
    condition     = can(regex("^https?://", var.allowed_origin))
    error_message = "Allowed origin must be a valid URL starting with http:// or https://."
  }
}

# Optional: Environment variable (for multi-environment setups)
variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "prod"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

# Optional: Tags for resource organization
variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    Project     = "CloudResume"
    ManagedBy   = "Terraform"
    Owner       = "Alston"
    Environment = "Production"
  }
}

# Optional: Lambda configuration
variable "lambda_runtime" {
  description = "Lambda function runtime"
  type        = string
  default     = "python3.11"

  validation {
    condition     = contains(["python3.9", "python3.10", "python3.11", "python3.12"], var.lambda_runtime)
    error_message = "Lambda runtime must be a supported Python version."
  }
}

variable "lambda_timeout" {
  description = "Lambda function timeout in seconds"
  type        = number
  default     = 10

  validation {
    condition     = var.lambda_timeout >= 3 && var.lambda_timeout <= 900
    error_message = "Lambda timeout must be between 3 and 900 seconds."
  }
}

variable "lambda_memory" {
  description = "Lambda function memory in MB"
  type        = number
  default     = 128

  validation {
    condition     = var.lambda_memory >= 128 && var.lambda_memory <= 10240
    error_message = "Lambda memory must be between 128 and 10240 MB."
  }
}

# Optional: DynamoDB configuration
variable "dynamodb_billing_mode" {
  description = "DynamoDB billing mode (PROVISIONED or PAY_PER_REQUEST)"
  type        = string
  default     = "PAY_PER_REQUEST"

  validation {
    condition     = contains(["PROVISIONED", "PAY_PER_REQUEST"], var.dynamodb_billing_mode)
    error_message = "Billing mode must be either PROVISIONED or PAY_PER_REQUEST."
  }
}

variable "enable_point_in_time_recovery" {
  description = "Enable point-in-time recovery for DynamoDB table"
  type        = bool
  default     = false # Set to true for production
}

# Optional: API Gateway configuration
variable "api_stage_name" {
  description = "API Gateway deployment stage name"
  type        = string
  default     = "prod"
}

variable "enable_api_gateway_logging" {
  description = "Enable CloudWatch logging for API Gateway"
  type        = bool
  default     = true
}

variable "api_throttle_burst_limit" {
  description = "API Gateway throttle burst limit"
  type        = number
  default     = 100
}

variable "api_throttle_rate_limit" {
  description = "API Gateway throttle rate limit (requests per second)"
  type        = number
  default     = 50
}
