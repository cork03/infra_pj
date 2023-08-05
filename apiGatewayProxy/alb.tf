resource "aws_lb" "alb" {
  name               = "test-alb"
  load_balancer_type = "application"
  internal           = false
  idle_timeout       = 60
  # 練習用で何回も削除する予定
  enable_deletion_protection = false

  subnets = [
    aws_subnet.public_alb_subnet_1a.id,
    aws_subnet.public_alb_subnet_1c.id
  ]

  access_logs {
    bucket  = aws_s3_bucket_policy.alb_log.id
    enabled = true
  }

  security_groups = [
    module.http_sg.security_group_id,
  ]
}

//####################################
//# ALB listeners
//####################################
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "これは「HTTP通信」です。"
      status_code  = "200"
    }
  }
}
resource "aws_lb_target_group" "lambda" {
  name        = "lambda-target-group"
  target_type = "lambda"
  port        = 80
  protocol    = "HTTP"
  # ターゲット解除時の待ち時間
  deregistration_delay = 10

  health_check {
    path                = "/"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = 200
    port                = "traffic-port"
    protocol            = "HTTP"
  }

  depends_on = [
    aws_lb.alb
  ]
}

resource "aws_lambda_permission" "alb" {
  statement_id  = "AllowExecutionFromlb"
  action        = "lambda:InvokeFunction"
  function_name = module.execute_lambda.lambda_function_name
  principal     = "elasticloadbalancing.amazonaws.com"
  source_arn    = aws_lb_target_group.lambda.arn
}

resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = aws_lb_target_group.lambda.arn
  target_id        = module.execute_lambda.lambda_arn
  depends_on       = [aws_lambda_permission.alb]
}

//デフォルトの紐付けルールに従うため明治的にそれ以上の権限を付与するイメージ
resource "aws_lb_listener_rule" "lambda" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 100
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lambda.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}

//####################################
//# security_groups
//####################################
module "http_sg" {
  source      = "./modules/securityGroup"
  name        = "http_sg"
  vpc_id      = aws_vpc.vpc.id
  port        = 80
  cidr_blocks = ["0.0.0.0/0"]
}
