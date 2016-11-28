resource "aws_api_gateway_resource" "main" {
  rest_api_id = "${var.rest_api_id}"
  parent_id   = "${var.parent_id}"
  path_part   = "${var.resource_part}"
}

resource "aws_api_gateway_method" "main" {
  rest_api_id   = "${var.rest_api_id}"
  resource_id   =  "${aws_api_gateway_resource.main.id}"
  http_method   = "${var.method}"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "main" {
  depends_on              = ["aws_api_gateway_method.main"] 
  rest_api_id             = "${var.rest_api_id}"
  type                    = "AWS_PROXY"
  resource_id             = "${aws_api_gateway_resource.main.id}"
  http_method             = "${aws_api_gateway_method.main.http_method}"
  uri                     = "arn:aws:apigateway:${element(split(":", "${var.lambda_arn}"), 3)}:lambda:path/2015-03-31/functions/${var.lambda_arn}/invocations"
  integration_http_method = "POST"
  # request_templates = {
  #   "application/json" = "${file("${path.module}/mappings.js")}"
  # }
}

resource "aws_api_gateway_integration_response" "200" {
  depends_on        = [ "aws_api_gateway_integration.main" ] 
  rest_api_id       = "${var.rest_api_id}"
  resource_id       = "${aws_api_gateway_resource.main.id}"
  http_method       = "${aws_api_gateway_method.main.http_method}"
  status_code       = "${aws_api_gateway_method_response.200.status_code}"
}

resource "aws_api_gateway_method_response" "200" {
  rest_api_id = "${var.rest_api_id}"
  resource_id = "${aws_api_gateway_resource.main.id}"
  http_method = "${aws_api_gateway_method.main.http_method}"
  status_code = "200"
}
# {aws_api_gateway_resource.main.path}
resource "aws_lambda_permission" "with_apig" {
    statement_id  = "${uuid()}"
    action        = "lambda:InvokeFunction"
    function_name = "${var.lambda_arn}"
    principal     = "apigateway.amazonaws.com"
    # lifecycle {
    #   prevent_destroy = true
    # }
    source_arn    = "arn:aws:execute-api:${element(split(":", "${var.lambda_arn}"), 3)}:${element(split(":", "${var.lambda_arn}"), 4)}:${var.rest_api_id}/*/${aws_api_gateway_method.main.http_method}${aws_api_gateway_resource.main.path}"
}