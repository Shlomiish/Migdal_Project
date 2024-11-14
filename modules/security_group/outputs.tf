output "bastion_sg_id" {
  value = module.bastion_sg.bastion_sg_id 
}

output "agent_sg_id" {
  value = module.ec2_sg.agent_private_sg_id
}

output "alb_sg_id" {
  value = module.alb_sg.alb_sg_id
}

output "gitlab_sg_id" {
  value = module.ec2_sg.gitlab_sg_id
}

output "jenkins_sg_id" {
  value = module.ec2_sg.jenkins_sg_id
}