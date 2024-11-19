### Load Balance Externo ###
resource "aws_lb" "lb_external" {
  name               = "enviohub-lb-external"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_group_id_public]
  subnets            = var.subnets

  tags = {
    Name = "enviohub-lb"
  }
}

resource "aws_lb_target_group" "lb_target_group_external" {
  name         = "enviohub-2-target-group"
  port         = 80
  protocol     = "HTTP"
  vpc_id       = var.vpc_id
  target_type  = "instance"

  health_check {
    path                = "/health"      # Pode ser configurado para qualquer rota disponível
    interval            = 30       # Tempo entre verificações
    timeout             = 5        # Tempo de espera por resposta
    healthy_threshold   = 2        # Threshold de sucesso
    unhealthy_threshold = 5        # Threshold de falha
  }
}

resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.lb_external.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_target_group_external.arn
  }
}