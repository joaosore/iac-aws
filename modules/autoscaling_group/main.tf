resource "aws_autoscaling_group" "ecs_autoscaling_group" {
  desired_capacity       = 2
  max_size               = 2
  min_size               = 2
  vpc_zone_identifier    = var.subnets
  
  launch_template {
    id      = aws_launch_template.ecs_launch_template.id
    version = "$Latest"
  }

  # Configura o Health Check e a proteção de instância
  health_check_type         = "EC2"
  health_check_grace_period = 300

  target_group_arns = [var.target_group_arn]

  tag {
    key                 = "AmazonECSManaged"
    value               = "true"
    propagate_at_launch = true
  }
}

# Captura as instâncias associadas ao Auto Scaling Group
data "aws_instances" "asg_instances" {
  instance_tags = {
    "aws:autoscaling:groupName" = aws_autoscaling_group.ecs_autoscaling_group.name
  }
}

locals {
  ec2_internal_ips = data.aws_instances.asg_instances.private_ips
}

data "aws_instances" "asg_instances2" {
  filter {
    name   = "tag:aws:autoscaling:groupName"
    values = [aws_autoscaling_group.ecs_autoscaling_group.name]
  }
}

locals {
  ec2_internal_ids = data.aws_instances.asg_instances2.ids
}