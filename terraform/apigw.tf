data "aws_caller_identity" "current" {}

data "aws_lambda_function" "crop_tool_lambda" {
  function_name = "crop-image"
}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

resource "aws_api_gateway_rest_api" "crop_tool_api" {
  name = var.crop_tool_api
  description = "API for handling POST requests to crop-tool application"
}

resource "aws_api_gateway_resource" "image_resource" {
  rest_api_id = aws_api_gateway_rest_api.crop_tool_api.id
  parent_id   = aws_api_gateway_rest_api.crop_tool_api.root_resource_id
  path_part   = var.path_part
}

resource "aws_api_gateway_method" "image_method" {
  rest_api_id   = aws_api_gateway_rest_api.crop_tool_api.id
  resource_id   = aws_api_gateway_resource.image_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.crop_tool_api.id
  resource_id             = aws_api_gateway_resource.image_resource.id
  http_method             = aws_api_gateway_method.image_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = data.aws_lambda_function.crop_tool_lambda.invoke_arn
}

resource "aws_api_gateway_deployment" "crop_tool_deployment" {
  rest_api_id       = aws_api_gateway_rest_api.crop_tool_api.id
  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.image_resource.id,
      aws_api_gateway_method.image_method.id,
      aws_api_gateway_integration.lambda_integration.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "image_stage" {
  deployment_id = aws_api_gateway_deployment.crop_tool_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.crop_tool_api.id
  stage_name    = "image"
}


resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = data.aws_lambda_function.crop_tool_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.crop_tool_api.id}/*/${aws_api_gateway_method.image_method.http_method}${aws_api_gateway_resource.image_resource.path}"
}
