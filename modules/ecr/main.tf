resource "aws_ecr_repository" "web_enviohub" {
  for_each = toset(var.ecr_names)

  name = each.value
  tags = {
    Name = "web-enviohub-${each.value}"
  }
}
