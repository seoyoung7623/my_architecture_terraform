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
    "name" = "seoyoung-lt"
  }
}

variable "ami" {
    type = string
}

variable "instance_type" {
    type  = string
    default = "t3.micro"
}

variable "port" {
    type  = number
}

variable "vpc_id" {
    type  = string
}

variable "alb_sg_id" {
    type  = string 
}

variable "pub_sub_1_cidr" {
  type = string
}

variable "pub_sub_2_cidr" {
  type = string
}