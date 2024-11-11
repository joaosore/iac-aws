output "ecr_repository_urls" {
  value = { for name, repo in aws_ecr_repository.web_enviohub : name => repo.repository_url }
}