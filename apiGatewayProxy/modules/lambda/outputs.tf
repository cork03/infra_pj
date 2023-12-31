output "lambda_arn" {
  value = aws_lambda_function.this.arn
}

output "cloudwatch_log_group_arn" {
  value = aws_cloudwatch_log_group.this.arn
}

output "lambda_invoke_arn" {
  value = aws_lambda_function.this.invoke_arn
}

output "lambda_function_name" {
  value = aws_lambda_function.this.function_name
}