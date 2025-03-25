# terraform {
#     required_version = ">= 1.0.0, < 2.0.0"
#     backend "s3" {
#         bucket = "seoyoung-terraform-state-s3"
#         key = "dev/terraform/terraform.tfstate"
#         region = "ap-northeast-2"
#         dynamodb_table = "seoyoung-terraform-state-lock"
#     }
# }

module "vpc" {
  source = "../modules/vpc"

  stage = var.stage
    servicename = var.servicename
    tags = var.tags

    vpc_cidr = var.vpc_cidr
    az = var.az
}

module "ec2" {
  source = "../modules/ec2"

  stage = var.stage
  servicename = var.servicename
  tags = var.tags

  ami = var.ami
  instance_type = var.instance_type
  subnet_id = module.vpc.subnet-public-az1.id
  # vpc모듈이 출력(output)을 제공해야한다.
  ssh_allow_ingress_list = var.ssh_allow_ingress_list 
}

# module "s3" {
#   source = "../modules/s3"
# }

module "alb" {
  source = "../modules/alb"

  subnet_ids = [
    module.vpc.subnet-public-az1.id,
    module.vpc.subnet-public-az2.id
  ]
  vpc_id = module.vpc.aws-vpc-id
  hc_path = var.hc_path
  hc_healty_threshold = var.hc_healty_threshold
  hc_unhealty_threshold = var.hc_unhealty_threshold
  target_type = var.target_type
  port = var.port
  aws_s3_lb_logs_name = var.aws_s3_lb_logs_name
  sg_allow_comm_list = var.sg_allow_comm_list
  asg-subnets = [
    module.vpc.subnet-private-az1.id,
    module.vpc.subnet-private-az2.id
  ]
  launch_template_id = module.launch_template.launch_template_id
  depends_on = [ module.vpc ]
}

module "launch_template" {
  source = "../modules/launch_template"

  ami = var.ami
  port = var.port
  vpc_id = module.vpc.aws-vpc-id
  instance_type = var.instance_type
  alb_sg_id = module.alb.alb-sg-id
  pub_sub_1_cidr = module.vpc.subnet-public-az1.cidr_block
  pub_sub_2_cidr = module.vpc.subnet-public-az2.cidr_block  
 }