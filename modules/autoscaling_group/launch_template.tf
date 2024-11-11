resource "random_string" "suffix" {
  length  = 5
  special = false
}

resource "aws_key_pair" "ecs_key_pair" {
  key_name   = "web-enviohub-key-${random_string.suffix.result}"
  public_key = tls_private_key.ecs_key.public_key_openssh
}

resource "tls_private_key" "ecs_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_launch_template" "ecs_launch_template" {
  name          = "web-enviohub-launch-template-${random_string.suffix.result}"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = "Teste"
  
  iam_instance_profile {
    arn = "arn:aws:iam::011528294225:instance-profile/ecsInstanceRole"
  }

  network_interfaces {
    device_index                = 0
    associate_public_ip_address = true
    security_groups             = var.security_group_ids
  }

   user_data = base64encode(<<-EOF
      #!/bin/bash
      echo "ECS_CLUSTER=${var.ecs_cluster_name}" >> /etc/ecs/ecs.config
    EOF
    )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name              = "web-enviohub-ec2-instance"
      AmazonECSManaged  = "true"
    }
  }
}