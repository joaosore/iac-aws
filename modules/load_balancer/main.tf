### Load Balance Externo ###
# resource "aws_lb" "lb_external" {
#   name               = "enviohub"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [var.security_group_id]
#   subnets            = var.subnets

#   tags = {
#     Name = "enviohub-lb"
#   }
# }

# resource "aws_lb_target_group" "lb_ecs_target_group" {
#   name         = "enviohub-2-target-group"
#   port         = 80
#   protocol     = "HTTP"
#   vpc_id       = var.vpc_id
#   target_type  = "instance"

#   health_check {
#     path                = "/health"      # Pode ser configurado para qualquer rota disponível
#     interval            = 30       # Tempo entre verificações
#     timeout             = 5        # Tempo de espera por resposta
#     healthy_threshold   = 2        # Threshold de sucesso
#     unhealthy_threshold = 5        # Threshold de falha
#   }
# }

# resource "aws_lb_listener" "lb_listener" {
#   load_balancer_arn = aws_lb.app_lb.arn
#   port              = 80
#   protocol          = "HTTP"
#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.ecs_target_group.arn
#   }
# }

### Load Balancer Interno ###
resource "aws_lb" "lb_internal" {
  name               = "enviohub-lb-internal"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [var.security_group_id_private]
  subnets            = var.subnets

  enable_deletion_protection = false
}

# Grupo de Destino
resource "aws_lb_target_group" "lb_target_group_internal" {
  name     = "enviohub-tg-internal"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type  = "instance"

  health_check {
    path                = "/health"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# Regra do Listener para o ALB
resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.lb_internal.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_target_group_internal.arn
  }
}

# # Anexa as instâncias EC2 ao grupo de destino
# resource "aws_lb_target_group_attachment" "app_tg_attachment" {
#   for_each         = toset(local.ec2_ids)
#   target_group_arn = aws_lb_target_group.app_tg.arn
#   target_id        = each.value
#   port             = 80
# }