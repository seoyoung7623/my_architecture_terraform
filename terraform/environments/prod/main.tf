terraform {
    required_version = ">= 1.0.0, < 2.0.0"
    backend "s3" {
        bucket = "seoyoung-terraform-state-s3"
        key = "prod/terraform/terraform.tfstate"
        region = "ap-northeast-2"
        dynamodb_table = "seoyoung-terraform-state-lock"
    }
}
module "vpc" {
  source = "../modules/vpc"

  stage       = var.stage
  servicename = var.servicename
  tags        = var.tags

  vpc_cidr = var.vpc_cidr
  az       = var.az
}

module "ec2" {
  source = "../modules/ec2"

  stage       = var.stage
  servicename = var.servicename
  tags        = var.tags

  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = module.vpc.subnet_public_az1.id
  # vpc모듈이 출력(output)을 제공해야한다.
  ssh_allow_ingress_list = var.ssh_allow_ingress_list
}

# module "s3" {
#   source = "../modules/s3"
# }

module "alb" {
  source = "../modules/alb"

  stage       = var.stage
  servicename = var.servicename
  tags        = var.tags

  internal = var.internal
  subnet_ids = [
    module.vpc.subnet_public_az1.id,
    module.vpc.subnet_public_az2.id
  ]
  vpc_id                = module.vpc.aws_vpc.id
  hc_path               = var.hc_path
  hc_healty_threshold   = var.hc_healty_threshold
  hc_unhealty_threshold = var.hc_unhealty_threshold
  target_type           = var.target_type
  port                  = var.port
  aws_s3_lb_logs_name   = var.aws_s3_lb_logs_name
  sg_allow_comm_list    = var.sg_allow_comm_list
  depends_on            = [module.vpc]
}

module "launch_template" {
  source = "../modules/launch_template"

  stage       = var.stage
  servicename = var.servicename
  tags        = var.tags

  ami            = var.ami
  port           = var.port
  vpc_id         = module.vpc.aws_vpc.id
  instance_type  = var.instance_type
  alb_sg_id      = module.alb.alb-sg-id
  pub_sub_1_cidr = module.vpc.subnet_public_az1.cidr_block
  pub_sub_2_cidr = module.vpc.subnet_public_az2.cidr_block
}

module "asg" {
  source = "../modules/asg"

  stage       = var.stage
  servicename = var.servicename
  tags        = var.tags

  launch_template_id = module.launch_template.launch_template_id
  asg-subnets = [
    module.vpc.subnet_private_az1.id,
    module.vpc.subnet_private_az2.id
  ]
  target_group_arn = module.alb.alb_target_group_arn
}

module "route53" {
  source = "../modules/route53"

  host_name    = var.host_name
  record_type  = var.record_type
  alb_dns_name = module.alb.alb_dns_name
  alb_zone_id  = module.alb.alb_zone_id
}