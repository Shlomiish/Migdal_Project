output "jenkins_sg_id" {
  value = aws_security_group.jenkins_sg.id
}

output "agent_private_sg_id" {
  value = aws_security_group.agent_sg.id
}

output "gitlab_sg_id" {
  value = aws_security_group.gitlab_sg.id
}