resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.cluster_name
}

locals {
  extra_hosts = [
    for idx, ip in var.ec2_internal_ips : {
      hostname  = "host${idx}.docker.internal"
      ipAddress = ip
    }
  ]
}

resource "aws_ecs_task_definition" "ecs_task_1" {
  family                   = "proxyreverse-enviohub-task"
  network_mode             = "bridge"  # Compatível com o tipo de instância EC2
  requires_compatibilities = ["EC2"]
  cpu                      = "128"
  memory                   = "128"
  execution_role_arn       = var.execution_role_arn
  container_definitions    = jsonencode([
    {
      name      = "ec2-proxyreverse-enviohub-services"
      image     = "011528294225.dkr.ecr.us-east-1.amazonaws.com/ec2-proxyreverse-enviohub-services:latest"
      cpu       = 128
      memory    = 128
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ],
      environment = [],
      extraHosts = local.extra_hosts,
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/aws/ecs/enviohub/ec2-proxyreverse-enviohub-services"
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "ecs"
        }
      },
    },
  ])
}

resource "aws_ecs_task_definition" "ecs_task_2" {
  family                   = "auth-enviohub-task"
  network_mode             = "bridge"  # Compatível com o tipo de instância EC2
  requires_compatibilities = ["EC2"]
  cpu                      = "256"
  memory                   = "256"
  execution_role_arn       = var.execution_role_arn
  container_definitions    = jsonencode([
    {
      name      = "ec2-auth-enviohub-services"
      image     = "011528294225.dkr.ecr.us-east-1.amazonaws.com/ec2-auth-enviohub-services:latest"
      cpu       = 256
      memory    = 256
      essential = true
      portMappings = [
        {
          containerPort = 3002
          hostPort      = 3002
          protocol      = "tcp"
        }
      ],
      environment = [
        { name = "NODE_ENV", value = "production" },
        { name = "DB_HOST", value = "13.90.172.219" },
        { name = "DB_USER", value = "rUPhJxYKIZIOWA6OTuge" },
        { name = "DB_PASSWORD", value = "fUWLo1i8ds11GKRYMVyN3AMlg83wORYbg2Vs" },
        { name = "DB_DATABASE", value = "HGAWEB" },
        { name = "DB_PORT", value = "1433" },
        { name = "PORT", value = "3002" },
        { name = "INSTANCES", value = "2" },
        { name = "URL", value = "http://localhost" },
        { name = "DEFAULT_LANG", value = "pt_BR" },
        { name = "ADMIN_USER", value = "admin" },
        { name = "ADMIN_PASSWORD", value = "admin" },
        { name = "SECRET_TOKEN", value = "8cd172e849ee2770cfa2e6eafcb0928dc7b6055e" },
        { name = "EXPIRES_IN_TOKEN", value = "1440m" },
        { name = "SECRET_REFRESH_TOKEN", value = "29118f6073e493e98495c90fc0407309" },
        { name = "EXPIRES_IN_REFRESH_TOKEN", value = "3h" },
        { name = "AZURE_AD_REDIRECT_URI", value = "http://localhost/services/auth/azure/callback" },
        { name = "AZURE_AD_REDIRECT_TO_CLIENT", value = "http://localhost/services/auth/doc/" },
        { name = "AZURE_AD_REDIRECT_TO_CLIENT_HML_BACK", value = "https://hgaweb.azurewebsites.net/services/auth/doc/" },
        { name = "AZURE_AD_REDIRECT_TO_CLIENT_HML_FRONT", value = "http://localhost:3000/login" },
        { name = "API_KEY_MAILERSEND", value = "mlsn.8bcac9ca01c48c36112f9575e32e05d1bc07e8c03db2836011954b7fb62e0c9d" },
        { name = "KEY", value = "44d218809b5251cb18eb0c68c67d648b71179678f34be1a613a4282fdea0edef" },
        { name = "IV", value = "0a469869d275939db7a5f3ee7d6f3abe" },
        { name = "X_API_KEY", value = "8cd172e849ee2770cfa2e6eafcb0928dc7b6055e" }
      ],
      extraHosts = local.extra_hosts,
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/aws/ecs/enviohub/ec2-auth-enviohub-services"
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "ecs_service_1" {
  name            = "ec2-proxyreverse-enviohub-services"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_1.arn
  desired_count   = 3
  launch_type     = "EC2"
}

resource "aws_ecs_service" "ecs_service_2" {
  name            = "ec2-auth-enviohub-services"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_2.arn
  desired_count   = 3
  launch_type     = "EC2"
}

resource "aws_ecs_capacity_provider" "ecs_capacity_provider" {
  name = "ec2-proxyreverse-enviohub-services-capacity-provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = var.autoscaling_group_arn  # Usando a variável em vez de module.ec2
    managed_scaling {
      status                    = "ENABLED"
      target_capacity           = 80
      minimum_scaling_step_size = 1
      maximum_scaling_step_size = 10
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "ecs_cluster_capacity_providers" {
  cluster_name       = aws_ecs_cluster.ecs_cluster.name  # Nome do ECS Cluster
  capacity_providers = [aws_ecs_capacity_provider.ecs_capacity_provider.name]  # Nome do Capacity Provider

  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.ecs_capacity_provider.name
    weight            = 1
    base              = 1
  }
}
