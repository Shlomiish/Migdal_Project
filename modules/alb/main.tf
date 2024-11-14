module "jenkins_alb" {
  source = "./jenkins_alb"
  vpc_id = var.vpc_id
  jenkins_server_id = var.jenkins_server_id
  public_subnet_ids = var.public_subnet_ids
  alb_sg_id = var.alb_sg_id
}

module "gitlab_alb" {
  source = "./gitlab_alb"
  vpc_id = var.vpc_id
  gitlab_server_id = var.gitlab_server_id
  public_subnet_ids = var.public_subnet_ids
  alb_sg_id = var.alb_sg_id
}