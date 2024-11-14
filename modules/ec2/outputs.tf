output "bastion_private_ip" {
  value = aws_instance.bastion_host.private_ip
}

output "jenkins_private_ip" {
  value = aws_instance.jenkins_server.private_ip
}

output "agent_private_ip" {
  value = aws_instance.agent_server.private_ip
}

output "jenkins_server_id" {
  value = aws_instance.jenkins_server.id
}

output "gitlab_server_id" {
  value = aws_instance.gitlab_server.id
}