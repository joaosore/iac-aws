output "security_group_id_public" {
  value = aws_security_group.lb_sg_public.id
}

output "security_group_id_private" {
  value = aws_security_group.lb_sg_private.id
}