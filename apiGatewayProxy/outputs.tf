//output "api_gateway_url" {
//  value = aws_apigatewayv2_stage.lambda_api.invoke_url
//}

output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}
