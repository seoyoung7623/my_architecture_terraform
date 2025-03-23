variable "stage" {
  default = "dev"
  type = string
}

variable "servicename" {
  default = "ec2"
  type = string
}

variable "tags" {
type = map(string)
  default = {
    "name" = "seoyoung-ec2"
  }
}

variable "ami" {
  description = "AMI ID"
}

variable "instance_type" {
  type  = string
  default = "t2.micro" #1c1m
}

variable "subnet_id" {
  type  = string
}

variable "ssh_allow_ingress_list" {
  type = list(string) 
}