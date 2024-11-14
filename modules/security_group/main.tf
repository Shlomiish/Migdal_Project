module "bastion_sg" {
  source    = "./bastion_sg"  
  vpc_id    = var.vpc_id      
  local_ip = var.local_ip     
}


module "ec2_sg" {
  source = "./ec2_sg"
  vpc_id = var.vpc_id
  bastion_private_ip = var.bastion_private_ip
  jenkins_private_ip = var.jenkins_private_ip
  alb_sg_id = module.alb_sg.alb_sg_id
  agent_private_ip = var.agent_private_ip
  
}

module "alb_sg" {
  source = "./alb_sg"
  vpc_id = var.vpc_id
}

