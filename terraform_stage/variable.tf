# 공통부분
variable "region" {
  description = "리전"
  type    = string
  default = "ap-northeast-2"
}

variable "stage" {
  description = "작업환경"
  type    = string
  default = "dev"
}

variable "servicename" {
  description = "서비스명"
  type    = string
  default = "terraform-seoyoung"
}

variable "tags" {
  description = "태그"
  type = map(string)
  default = {
    "Owner" = "seoyoung"
  }
}

#VPC
variable "az" {
  description = "가용영역"
  type    = list(any)
  default = ["ap-northeast-2a", "ap-northeast-2c"]
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type    = string
  default = "172.16.1.0/24"
}
# VPC에서 서브넷 나누는 방법
# 서브넷이 6개 필요하다면, 2의 n승으로 나누어야 한다.
# 2의 3승은 8이므로, 8개의 서브넷을 만들 수 있다.
# vpc가 /24이므로, 서브넷은 /27로 나누어야 한다.


##Instance
variable "ami" {
  description = "AMI"
  type    = string
  default = "ami-0d5bb3742db8fc264" # Ubuntu 24.04
}

variable "key_name" {
  description = "EC2 Key Pair Name"
  type    = string
  default = "seoyoung-ec2-key"
}

variable "instance_type" {
  description = "인스턴스 타입"
  type    = string
  default = "t2.micro"
}

variable "instance_ebs_size" {
  description = "인스턴스 EBS 사이즈"
  type    = number
  default = 20
}
variable "instance_ebs_volume" {
  type    = string
  default = "gp3"
}

variable "ssh_allow_ingress_list" {
  description = "SSH 접속 허용 IP, 내 IP"
  default = ["211.192.32.69/32","0.0.0.0/0"] # 내 고정 IP
}

# ALB

variable "internal" {
  type    = bool
  default = false # 퍼블릭 ALB
}
variable "idle_timeout" {
  type    = number
  default = 60
}

variable "aws_s3_lb_logs_name" {
  type    = string
  default = "seoyoung-alb-logs-s3"
}

# Health Check
variable "port" {
  type    = number
  default = 80
}

variable "target_type" {
  type    = string
  default = "instance"
}

variable "hc_path" {
  type    = string
  default = "/"
}

variable "hc_healty_threshold" {
  type    = number
  default = 2
}

variable "hc_unhealty_threshold" {
  type    = number
  default = 2
}
variable "sg_allow_comm_list" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

# route53
variable "host_name" {
  type    = string
  default = "seoyoungstudy.shop"
}

variable "record_type" {
  type    = string
  default = "A"
}

# S3
variable "frontend_bucket" {
    description = "The bucket name"
    type        = string
    default = "frontend-bucket-seoyoung-terraform-s3"
}

# Cloudfront
variable "dev_domain_name" {
  type        = string
  description = "사용할 커스텀 도메인"
  default = "dev.seoyoungstudy.shop"
}