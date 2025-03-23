variable "region" {
  type = string
  default = "ap-northeast-2"
}

variable "stage" {
  type = string
  default = "stage"
}

variable "servicename" {
  type = string
  default = "terraform_seoyoung"
}

variable "tags" {
  type = map(string)
  default = {
    "name" = "seoyoung_VPC"
  }
}

#VPC
variable "az" {
  type = list(any)
  default = [ "ap-northeast-2a", "ap-northeast-2c" ]
}

variable "vpc_ip_range" {
  type = string
  default = "172.16.1.0/24"
}
# VPC에서 서브넷 나누는 방법
# 서브넷이 6개 필요하다면, 2의 n승으로 나누어야 한다.
# 2의 3승은 8이므로, 8개의 서브넷을 만들 수 있다.
# vpc가 /24이므로, 서브넷은 /27로 나누어야 한다.


##Instance
variable "ami"{
  type = string
  default = "ami-0d5bb3742db8fc264" # Ubuntu 24.04
}
variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "instance_ebs_size" {
  type = number
  default = 20
}
variable "instance_ebs_volume" {
  type = string
  default = "gp3"
}

variable "ssh_allow_ingress_list" {
  default = ["211.192.32.69/32"]
}

# variable "instance_user_data" {
#   type = string
# }
# variable "redis_endpoints" {
#   type = list
# }

##RDS
variable "rds_dbname" {
  type = string
  default = "seoyoung-rds"
}
variable "rds_instance_count" {
  type = string
  default = "2"
}
variable "sg_allow_ingress_list_aurora"{
  type = list
  default = ["10.2.92.64/26", "10.2.92.128/26", "10.2.92.18/32"]
}
variable "associate_public_ip_address" {
  type = bool
  default = true
}

##KMS
variable "rds_kms_arn" {
  type = string
  default = "arn:aws:kms:ap-northeast-2:471112992234:key/1dbf43f7-1847-434c-bc3c-1beb1b86e480"
}
variable "ebs_kms_key_id" {
  type = string
  default = "arn:aws:kms:ap-northeast-2:471112992234:key/43b0228d-0a06-465c-b25c-7480b07b5276"
}
