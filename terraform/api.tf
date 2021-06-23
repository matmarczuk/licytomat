resource "aws_api_gateway_rest_api" "LicytomatAPI" {
  name        = "LicytomatAPI"
  description = "API for Licytomat project"
}

resource "aws_api_gateway_deployment" "LicytomatAPIDeployment" {
  depends_on = [module.AuctionsResource, module.AuctionResource]
  rest_api_id = aws_api_gateway_rest_api.LicytomatAPI.id
  stage_name  = "test"
  lifecycle {
    create_before_destroy = true
  }
}

#Resources
resource "aws_api_gateway_resource" "AimResource" {
  rest_api_id = aws_api_gateway_rest_api.LicytomatAPI.id
  parent_id   = aws_api_gateway_rest_api.LicytomatAPI.root_resource_id
  path_part   = "{aim}"
}

module "AuctionsResource" {
  source = "mewa/serverless-resource/aws"
  version = "2.0.0"
  api = aws_api_gateway_rest_api.LicytomatAPI.id
  root_resource = aws_api_gateway_resource.AimResource.id
  resource = "auctions"
  methods = [
    {
      method = "GET"
      type = "AWS_PROXY", # Optionally override lambda integration type, defaults to "AWS_PROXY"
      invoke_arn = module.GetAuctionsListLambda.lambda_function_invoke_arn
    }
  ]
}

module "AuctionResource" {
  source = "mewa/serverless-resource/aws"
  version = "2.0.0"
  api = aws_api_gateway_rest_api.LicytomatAPI.id
  root_resource = aws_api_gateway_rest_api.LicytomatAPI.root_resource_id
  resource = "auction"
  methods = [
    {
      method = "PUT"
      type = "AWS_PROXY" # Optionally override lambda integration type, defaults to "AWS_PROXY"
      invoke_arn = module.AddAuctionLambda.lambda_function_invoke_arn
    }
  ]
}

module "IdResource" {
  source = "mewa/serverless-resource/aws"
  version = "2.0.0"
  api = aws_api_gateway_rest_api.LicytomatAPI.id
  root_resource = module.AuctionResource.resource
  resource = "{id}"
  methods = [
    {
      method = "GET"
      type = "AWS_PROXY", # Optionally override lambda integration type, defaults to "AWS_PROXY"
      invoke_arn = module.GetAuctionLambda.lambda_function_invoke_arn
    }
  ]
}

module "ImageResource" {
  source = "mewa/serverless-resource/aws"
  version = "2.0.0"
  api = aws_api_gateway_rest_api.LicytomatAPI.id
  root_resource = module.AuctionResource.resource
  resource = "image"
  methods = []
}

module "UrlResource" {
  source = "mewa/serverless-resource/aws"
  version = "2.0.0"
  api = aws_api_gateway_rest_api.LicytomatAPI.id
  root_resource = module.ImageResource.resource
  resource = "url"
  methods = [
    {
      method = "GET"
      type = "AWS_PROXY", # Optionally override lambda integration type, defaults to "AWS_PROXY"
      invoke_arn = module.GetImgUrlLambda.lambda_function_invoke_arn
    }
  ]
}

module "BidResource" {
  source = "mewa/serverless-resource/aws"
  version = "2.0.0"
  api = aws_api_gateway_rest_api.LicytomatAPI.id
  root_resource = module.IdResource.resource
  resource = "bid"
  methods = [
    {
      method = "PUT"
      type = "AWS_PROXY", # Optionally override lambda integration type, defaults to "AWS_PROXY"
      invoke_arn = module.BidLambda.lambda_function_invoke_arn
    }
  ]
}

#Lambdas
module "GetAuctionsListLambda" {
  source = "terraform-aws-modules/lambda/aws"
  publish = true
  function_name = "LicytomatGetAuctionsListLambda"
  description   = "Get auctions list of specific aim"
  handler       = "LicytomatGetAuctionsListLambda.lambda_handler"
  runtime       = "python3.8"
  source_path = "./src/LicytomatGetAuctionsListLambda.py"
  tags = {
    Name = "Licytomat"
  }
  allowed_triggers = {
    APIGatewayAny = {
      service = "apigateway"
      arn     = aws_api_gateway_rest_api.LicytomatAPI.execution_arn
    }
  }
  attach_policy = true
  policy = "${data.aws_iam_policy.DynamoDBReadOnly.arn}"
}

module "GetAuctionLambda" {
  source = "terraform-aws-modules/lambda/aws"
  publish = true
  function_name = "LicytomatAuctionByIdLambda"
  description   = "Get detail description about specific auction"
  handler       = "LicytomatGetAuctionByIdLambda.lambda_handler"
  runtime       = "python3.8"
  source_path = "./src/LicytomatGetAuctionByIdLambda.py"
  tags = {
    Name = "Licytomat"
  }
  allowed_triggers = {
    APIGatewayAny = {
      service = "apigateway"
      arn     = aws_api_gateway_rest_api.LicytomatAPI.execution_arn
    }
  }
  attach_policy = true
  policy = "${data.aws_iam_policy.DynamoDBReadOnly.arn}"
}

module "GetImgUrlLambda" {
  source = "terraform-aws-modules/lambda/aws"
  publish = true
  function_name = "LicytomatGetImgUrlLambda"
  description   = "Get generated url to upload the image"
  handler       = "LicytomatGetImgUrlLambda.lambda_handler"
  runtime       = "python3.8"
  source_path = "./src/LicytomatGetImgUrlLambda.py"
  tags = {
    Name = "Licytomat"
  }
  allowed_triggers = {
    APIGatewayAny = {
      service = "apigateway"
      arn     = aws_api_gateway_rest_api.LicytomatAPI.execution_arn
    }
  }
}

module "BidLambda" {
  source = "terraform-aws-modules/lambda/aws"
  publish = true
  function_name = "LicytomatBidLambda"
  description   = "Get auctions list of specific aim"
  handler       = "LicytomatBidLambda.lambda_handler"
  runtime       = "python3.8"
  source_path = "./src/LicytomatBidLambda.py"
  tags = {
    Name = "Licytomat"
  }
  allowed_triggers = {
    APIGatewayAny = {
      service = "apigateway"
      arn     = aws_api_gateway_rest_api.LicytomatAPI.execution_arn
    }
  }
  attach_policy = true
  policy = aws_iam_policy.DynamoDBUpdateItem.arn
}

module "AddAuctionLambda" {
  source = "terraform-aws-modules/lambda/aws"
  publish = true
  function_name = "LicytomatAddAuctionLambda"
  description   = "Get auctions list of specific aim"
  handler       = "LicytomatAddAuctionLambda.lambda_handler"
  runtime       = "python3.8"
  source_path = "./src/LicytomatAddAuctionLambda.py"
  tags = {
    Name = "Licytomat"
  }
  allowed_triggers = {
    APIGatewayAny = {
      service = "apigateway"
      arn     = aws_api_gateway_rest_api.LicytomatAPI.execution_arn
    }
  }
  attach_policy = true
  policy = aws_iam_policy.DynamoDBPutItem.arn
}

data "aws_iam_policy" "DynamoDBReadOnly" {
  arn = "arn:aws:iam::aws:policy/AmazonDynamoDBReadOnlyAccess"
}

resource "aws_iam_policy" "DynamoDBUpdateItem" {
  name        = "DynamoDBUpdateItem"
  path        = "/"
  description = "Enable to Update Item in DB table"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "dynamodb:UpdateItem",
            "Resource": "arn:aws:dynamodb:eu-west-1:901282543326:table/Auctions"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "DynamoDBPutItem" {
  name        = "DynamoDBPutItem"
  path        = "/"
  description = "Enable to Put Item in DB table"

  policy = <<EOF
{
  "Version": "2012-10-17",
      "Statement": [
          {
              "Sid": "VisualEditor0",
              "Effect": "Allow",
              "Action": "dynamodb:PutItem",
              "Resource": "arn:aws:dynamodb:eu-west-1:901282543326:table/Auctions"
          }
      ]
}
EOF
}