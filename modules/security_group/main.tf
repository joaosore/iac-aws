# Grupo de Segurança Pública
resource "aws_security_group" "lb_sg_public" {
  name        = "${var.sg_name}-public"
  description = "Security group for the load balancer"
  vpc_id      = var.vpc_id  # Use var.vpc_id agora

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.sg_name
  }
}

# Grupo de Segurança Privado
resource "aws_security_group" "lb_sg_private" {
  name        = "${var.sg_name}-private"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.50.0/24"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

