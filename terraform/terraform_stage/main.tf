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

    vpc_ip_range = var.vpc_ip_range
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