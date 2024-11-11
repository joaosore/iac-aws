resource "random_string" "suffix" {
  length  = 5
  special = false
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs_task_execution_role_${random_string.suffix.result}"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Effect": "Allow",
        "Principal": {
          "Service": ["ecs-tasks.amazonaws.com", "ec2.amazonaws.com"],
        }
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "ecs_task_execution_policy" {
  name       = "ecs-task-execution-policy-attachment"
  roles      = [aws_iam_role.ecs_task_execution_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}