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