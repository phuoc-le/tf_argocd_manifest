################################################################################
# API Gateway
################################################################################
resource "aws_api_gateway_rest_api" "demo_api" {
  name        = var.api_gateway_name
  description = var.api_gateway_description

  endpoint_configuration {
    types = var.api_gateway_type
  }
}

resource "aws_api_gateway_authorizer" "demo" {
  name          = var.api_gateway_authorizer_name
  rest_api_id   = aws_api_gateway_rest_api.demo_api.id
  type          = var.api_gateway_authorizer_type
  provider_arns = [aws_cognito_user_pool.pool.arn]
}

resource "aws_api_gateway_resource" "root" {
  rest_api_id = aws_api_gateway_rest_api.demo_api.id
  parent_id   = aws_api_gateway_rest_api.demo_api.root_resource_id
  path_part   = var.api_gateway_path_part
}

resource "aws_api_gateway_method" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.demo_api.id
  resource_id = aws_api_gateway_resource.root.id
  http_method = "POST"

  //authorization = "NONE" // comment this out in cognito section
  authorization = var.api_gateway_authorizer_type
  authorizer_id = aws_api_gateway_authorizer.demo.id
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.demo_api.id
  resource_id             = aws_api_gateway_resource.root.id
  http_method             = aws_api_gateway_method.proxy.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.demo_lambda.invoke_arn
}

resource "aws_api_gateway_method_response" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.demo_api.id
  resource_id = aws_api_gateway_resource.root.id
  http_method = aws_api_gateway_method.proxy.http_method
  status_code = "200"

  //cors section
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }

}

resource "aws_api_gateway_integration_response" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.demo_api.id
  resource_id = aws_api_gateway_resource.root.id
  http_method = aws_api_gateway_method.proxy.http_method
  status_code = aws_api_gateway_method_response.proxy.status_code


  //cors
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  depends_on = [
    aws_api_gateway_method.proxy,
    aws_api_gateway_integration.lambda_integration
  ]
}

//options
resource "aws_api_gateway_method" "options" {
  rest_api_id = aws_api_gateway_rest_api.demo_api.id
  resource_id = aws_api_gateway_resource.root.id
  http_method = "OPTIONS"
  #   authorization = "NONE"

  authorization = var.api_gateway_authorizer_type
  authorizer_id = aws_api_gateway_authorizer.demo.id
}

resource "aws_api_gateway_integration" "options_integration" {
  rest_api_id             = aws_api_gateway_rest_api.demo_api.id
  resource_id             = aws_api_gateway_resource.root.id
  http_method             = aws_api_gateway_method.options.http_method
  integration_http_method = "OPTIONS"
  type                    = "MOCK"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_method_response" "options_response" {
  rest_api_id = aws_api_gateway_rest_api.demo_api.id
  resource_id = aws_api_gateway_resource.root.id
  http_method = aws_api_gateway_method.options.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration_response" "options_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.demo_api.id
  resource_id = aws_api_gateway_resource.root.id
  http_method = aws_api_gateway_method.options.http_method
  status_code = aws_api_gateway_method_response.options_response.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  depends_on = [
    aws_api_gateway_method.options,
    aws_api_gateway_integration.options_integration,
  ]
}

resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [
    aws_api_gateway_integration.lambda_integration,
    aws_api_gateway_integration.options_integration, # Add this line
  ]

  rest_api_id = aws_api_gateway_rest_api.demo_api.id
  stage_name  = var.env
}

################################################################################
# Lambda
################################################################################

resource "aws_lambda_function" "demo_lambda" {
  filename         = "index.zip"
  function_name    = var.lambda_function_name
  role             = aws_iam_role.lambda_role.arn
  handler          = "index.hello"
  runtime          = "nodejs20.x"
  source_code_hash = data.archive_file.lambda_package.output_base64sha256
}

resource "aws_iam_role" "lambda_role" {
  name = var.lambda_role

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_role.name
}

resource "aws_lambda_permission" "api_gateway_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.demo_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.demo_api.execution_arn}/*/*/*"
}

data "archive_file" "lambda_package" {
  type        = "zip"
  source_file = "index.js"
  output_path = "index.zip"
}

################################################################################
# Cognito
################################################################################

resource "aws_cognito_user_pool" "pool" {
  name = var.cognito_user_pool_name
}

resource "aws_cognito_user_pool_client" "client" {
  name                                 = var.cognito_user_pool_client_name
  allowed_oauth_flows_user_pool_client = true
  generate_secret                      = false
  allowed_oauth_scopes                 = ["aws.cognito.signin.user.admin", "email", "openid", "profile"]
  allowed_oauth_flows                  = ["implicit", "code"]
  explicit_auth_flows                  = ["ADMIN_NO_SRP_AUTH", "USER_PASSWORD_AUTH"]
  supported_identity_providers         = ["COGNITO"]


  user_pool_id  = aws_cognito_user_pool.pool.id
  callback_urls = var.cognito_callback_urls
  logout_urls   = var.cognito_logout_urls
}

resource "aws_cognito_user" "phuoclh" {
  user_pool_id = aws_cognito_user_pool.pool.id
  username     = var.cognito_username
  password     = var.cognito_password
}

################################################################################
# EKS
################################################################################

module "vpc" {
  source = "./modules/vpc"
  env = var.env
  vpc_name = var.vpc_name
  cluster_name = var.eks_cluster_name
  cidrs = var.cidrs
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  eks_worker_subnet_cidrs = var.eks_worker_subnet_cidrs
  eks_control_plane_subnet_cidrs = var.eks_control_plane_subnet_cidrs
  azs = var.azs
}

module "eks" {
  source  = "./modules/eks"
  cluster_name    = var.eks_cluster_name
  cluster_version = var.eks_cluster_version
  env = var.env
  vpc_id                         = module.vpc.vpc_id
  subnet_ids                     = module.vpc.eks_worker_subnet_ids
  control_plane_subnet_ids       = module.vpc.eks_control_plane_subnet_ids
  cluster_endpoint_public_access = true
  cluster_security_group_name    = "${var.eks_cluster_name}-cluster"
  node_security_group_name       = "${var.eks_cluster_name}-node"
  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"
    iam_role_attach_cni_policy = true
    disk_size            = 100
    block_device_mappings = {
      xvda = {
        device_name = "/dev/xvda"
        ebs = {
          volume_size           = 100
          volume_type           = "gp3"
          iops                  = 3000
          throughput            = 150
          encrypted             = false
          delete_on_termination = true
        }
      }
    }
  }
  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent              = true
      before_compute           = true
      service_account_role_arn = module.vpc_cni_irsa.iam_role_arn
      configuration_values = jsonencode({
        env = {
          ENABLE_PREFIX_DELEGATION = "true"
          WARM_PREFIX_TARGET       = "1"
        }
      })
    }
  }

  eks_managed_node_groups = {
    default = {
      name                 = "default"
      use_name_prefix      = false
      launch_template_name = "${var.eks_cluster_name}-default-launch-template"
      #      remote_access = {
      #        ec2_ssh_key               = ""
      #        source_security_group_ids = []
      #      }
      ebs_optimized           = true
      instance_types       = ["t3.xlarge", "t3a.xlarge"]
      disk_size            = 50
      capacity_type        = "ON_DEMAND" #ON_DEMAND,SPOT
      min_size             = 1
      max_size             = 3
      desired_size         = 1
      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = 50
            volume_type           = "gp3"
            iops                  = 3000
            throughput            = 150
            encrypted             = false
            delete_on_termination = true
          }
        }
      }
      labels = {
        nodegroup-name = "default"
        cluster-name  = var.eks_cluster_name
      }
    }
  }
}


data "aws_iam_policy" "ebs_csi_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

module "irsa-ebs-csi" {
  source  = "./modules/eks/modules/iam-assumable-role-with-oidc"

  create_role                   = true
  role_name                     = "AmazonEKSTFEBSCSIRole_${var.env}"
  provider_url                  = module.eks.oidc_provider
  role_policy_arns              = [data.aws_iam_policy.ebs_csi_policy.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
}


resource "aws_eks_addon" "ebs-csi" {
  cluster_name             = module.eks.cluster_name
  addon_name               = "aws-ebs-csi-driver"
  addon_version            = "v1.28.0-eksbuild.1"
  service_account_role_arn = module.irsa-ebs-csi.iam_role_arn
  tags = {
    "eks_addon" = "ebs-csi"
    "terraform" = "true"
  }
}

module "vpc_cni_irsa" {
  source  = "./modules/eks/modules/iam-role-for-service-accounts-eks"

  role_name = "AmazonEKS_CNI_Policy_${var.env}"
  attach_vpc_cni_policy = true
  vpc_cni_enable_ipv4   = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-node"]
    }
  }

  tags = {
    "Name": "AmazonEKS_CNI_Policy_${var.env}"
  }
}

################################################################################
# RDS Aurora
################################################################################

module "rds_postgres_aurora" {
  source = "./modules/rds"
  name           = var.rds_postgres_name
  engine         = "aurora-postgresql"
  engine_version = "14.5"
  instance_class = "db.t3.medium"
  instances = {
    writer = {
      instance_class = "db.t3.medium"
    }
    reader = {
      instance_class = "db.t3.medium"
    }
  }
  database_name = "postgres"
  master_username = "postgres"
  master_password = "Test@123"
  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.private_subnet_ids
  allowed_security_groups = []
  allowed_cidr_blocks     = ["10.0.0.0/16"]
  #  skip_final_snapshot = true
  #  snapshot_identifier = "arn:aws:rds:us-east-1:xxxxxx:cluster-snapshot:backup-10-04-2024"

  storage_encrypted   = false
  apply_immediately   = true
  monitoring_interval = 10

  db_parameter_group_name         = "default.aurora-postgresql14"
  db_cluster_parameter_group_name = "default.aurora-postgresql14"

  enabled_cloudwatch_logs_exports = ["postgresql"]
  iam_role_name = "rds-monitoring-role"
  performance_insights_enabled = true
  performance_insights_retention_period = 7

  tags = {
    Environment = var.env
    Name = var.rds_postgres_name
    Terraform   = "true"
  }
}
