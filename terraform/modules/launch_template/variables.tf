variable "stage" {
  type = string
}

variable "servicename" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "ami" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "port" {
  type = number
}

variable "vpc_id" {
  type = string
}

variable "alb_sg_id" {
  type = string
}

variable "pub_sub_1_cidr" {
  type = string
}

variable "pub_sub_2_cidr" {
  type = string
}