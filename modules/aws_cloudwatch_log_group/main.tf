resource "aws_cloudwatch_log_group" "ecs_log_group_1" {
  name              = "/aws/ecs/enviohub/ec2-auth-enviohub-services"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "ecs_log_group_2" {
  name              = "/aws/ecs/enviohub/ec2-proxyreverse-enviohub-services"
  retention_in_days = 7
}