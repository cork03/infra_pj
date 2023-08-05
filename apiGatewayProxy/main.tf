module "execute_lambda" {
  source        = "./modules/lambda"
  source_file   = "${path.module}/lambdaFunctions/execute.py"
  output_path   = "${path.module}/functionsZips/execute.zip"
  s3_bucket_id  = aws_s3_bucket.this.id
  s3_object_key = "execute.zip"
  function_name = "execute"
  handler       = "execute.handler"
  lambda_variables = {}
  lambda_iam_arn = module.execute_lambda_role.iam_role_arn
//  layers = ["arn:aws:lambda:ap-northeast-1:770693421928:layer:Klayers-p39-requests:15"]
  layers = []
}

//apiGatewayLambda
data "aws_iam_policy_document" "execute_lambda" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
    ]
    resources = ["arn:aws:logs:ap-northeast-1:463196187961:*"]
  }
   statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = ["${module.execute_lambda.cloudwatch_log_group_arn}:*"]
  }
}

module "execute_lambda_role" {
  source     = "./modules/iamRole"
  name       = "${local.project_name}_alb_lambda_role"
  policy     = data.aws_iam_policy_document.execute_lambda.json
  identifier = "lambda.amazonaws.com"
}