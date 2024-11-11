output "ecs_task_execution_role_arn" {
  description = "ARN do role ECS para execução de tarefas"
  value       = aws_iam_role.ecs_task_execution_role.arn
}