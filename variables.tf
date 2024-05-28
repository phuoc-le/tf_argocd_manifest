variable "env" {
  type        = string
  description = "environment"
  default     = "demo"
}

################################################################################
# Lambda
################################################################################

variable "lambda_function_name" {
  type        = string
  description = "lambda_function_name"
  default     = "DemoApiFunction"
}

variable "lambda_role" {
  type        = string
  description = "lambda_role"
  default     = "lambda-role"
}

################################################################################
# API Gateway
################################################################################

variable "api_gateway_name" {
  type        = string
  description = "api_gateway_name"
  default     = "demo-tf-api"
}

variable "api_gateway_description" {
  type        = string
  description = "api_gateway_description"
  default     = "Demo API Gateway"
}

variable "api_gateway_type" {
  type        = list(string)
  description = "api_gateway_type"
  default     = ["REGIONAL"]
}

variable "api_gateway_authorizer_name" {
  type        = string
  description = "api_gateway_authorizer_name"
  default     = "demo_api_gateway_authorizer"
}

variable "api_gateway_path_part" {
  type        = string
  description = "api_gateway_path_part"
  default     = "demo_path"
}

variable "api_gateway_authorizer_type" {
  type        = string
  description = "api_gateway_authorizer_type"
  default     = "COGNITO_USER_POOLS"
}

################################################################################
# Cognito
################################################################################

variable "cognito_user_pool_name" {
  type        = string
  description = "cognito_user_pool_name"
  default     = "demo-tf-api"
}

variable "cognito_user_pool_client_name" {
  type        = string
  description = "cognito_user_pool_client_name"
  default     = "demo-tf-client"
}

variable "cognito_callback_urls" {
  type        = list(string)
  description = "cognito_callback_urls"
  default     = ["https://phuocle.me"]
}

variable "cognito_logout_urls" {
  type        = list(string)
  description = "cognito_logout_urls"
  default     = ["https://phuocle.me"]
}

variable "cognito_username" {
  type        = string
  description = "cognito_username"
  default     = "phuoclh"
}

variable "cognito_password" {
  type        = string
  description = "cognito_password"
  default     = "Test@123"
}

################################################################################
# VPC
################################################################################

variable "cidrs" {
  type        = string
  description = "CIDR values"
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  type        = string
  description = "VPC Name"
  default     = "Demo VPC"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public Subnet CIDR values"
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private Subnet CIDR values"
  default     = ["10.0.69.0/24", "10.0.70.0/24", "10.0.71.0/24"]
}

variable "eks_worker_subnet_cidrs" {
  type        = list(string)
  description = "EKS Worker Subnet CIDR values"
  default     = ["10.0.72.0/22", "10.0.76.0/22", "10.0.80.0/22"]
}

variable "eks_control_plane_subnet_cidrs" {
  type        = list(string)
  description = "EKS Control Plane Subnet CIDR values"
  default     = ["10.0.85.0/24", "10.0.86.0/24", "10.0.87.0/24"]
}

variable "azs" {
  type        = list(string)
  description = "Availability Zones"
  default     = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
}

variable "cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks."
  default     = ["0.0.0.0/0"]
}

variable "ipv6_cidr_blocks" {
  type        = list(string)
  description = "List of IPv6 CIDR blocks."
  default     = ["::/0"]
}

################################################################################
# EKS
################################################################################

variable "eks_cluster_name" {
  type        = string
  description = "EKS Cluster Name"
  default     = "demo-eks"
}

variable "eks_cluster_version" {
  type        = string
  description = "EKS Cluster Version"
  default     = "1.29"
}

################################################################################
# RDS Aurora
################################################################################

variable "rds_postgres_name" {
  type        = string
  description = "RDS Postgres name"
  default     = "demo-aurora-postgres-db"
}

