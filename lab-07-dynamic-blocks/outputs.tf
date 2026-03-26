output "security_group_id" {
  description = "ID of the dynamic security group"
  value       = aws_security_group.dynamic_sg.id
}

output "ingress_rule_count" {
  description = "Number of ingress rules generated"
  value       = length(var.sg_ingress_rules)
}