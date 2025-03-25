variable "stage" {
    type  = string
    default = "dev"
}
variable "servicename" {
    type  = string
    default = "seoyoung"
}
variable "tags" {
  type = map(string)
  default = {
    "name" = "seoyoung-alb"
  }
}

variable "internal" {
    type  = bool
    # default = true # 내부망을 사용하려면 주석 해제
    default = false 
}

variable "subnet_ids" {
    type  = list
    default = []
}

variable "idle_timeout" {
    type  = number
    default = 60
}

variable "vpc_id" {
    type  = string
}

variable "aws_s3_lb_logs_name" {
    type  = string
}

# Health Check
variable "port" {
    type  = number
}

variable "target_type" {
    type  = string
}

variable "hc_path" {
  type = string
}

variable "hc_healty_threshold" {
    type = number
}

variable "hc_unhealty_threshold" {
  type = number
}

variable "sg_allow_comm_list" {
  type = list(string)
}