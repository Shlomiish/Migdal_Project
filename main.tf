provider "aws" {
  region = var.region
}

terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
     helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12.1"
    }
  }
}

data "aws_eks_cluster" "eks" {
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token
}


module "vpc" {
  source               = "./modules/vpc"
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  azs                  = var.azs
}


module "ec2" {
  source = "./modules/ec2"
  private_subnet_1_id = module.vpc.private_subnet_1_id
  private_subnet_2_id = module.vpc.private_subnet_2_id
  public_subnet_1_id = module.vpc.public_subnet_1_id
  vpc_id = module.vpc.vpc_id
  ami_list = var.ami_list
  bastion_sg_id = module.security_group.bastion_sg_id
  key_pair = var.key_pair
  instance_type = var.instance_type
  agent_private_sg_id = module.security_group.agent_sg_id
  gitlab_sg_id = module.security_group.gitlab_sg_id
  jenkins_sg_id = module.security_group.jenkins_sg_id

}


module "security_group" {
  source    = "./modules/security_group"  
  vpc_id    = module.vpc.vpc_id                  
  local_ip  = var.local_ip                
  bastion_private_ip = module.ec2.bastion_private_ip 
  jenkins_private_ip = module.ec2.jenkins_private_ip
  agent_private_ip = module.ec2.agent_private_ip
}

module "alb" {
  source = "./modules/alb"
  vpc_id = module.vpc.vpc_id
  public_subnet_ids = [module.vpc.public_subnet_1_id, module.vpc.public_subnet_2_id]
  alb_sg_id = module.security_group.alb_sg_id
  jenkins_server_id = module.ec2.jenkins_server_id
  gitlab_server_id = module.ec2.gitlab_server_id 
}

module "eks" {
  source = "./modules/eks"
  cluster_name = var.cluster_name
  vpc_id = module.vpc.vpc_id
  private_subnet_ids = [module.vpc.private_subnet_1_id, module.vpc.private_subnet_2_id]
  
}

module "deployment" {
  source = "./modules/deployment"
  cluster_name = var.cluster_name
  app_image = var.app_image
}