# 공통부분
variable "stage" {
  type = string
}

variable "servicename" {
  type = string
}

variable "tags" {
  type = map(string)
}

# EC2
variable "ami" {
  description = "AMI ID"
  type        = string
}

variable "key_name" {
  description = "EC2 Key Pair Name"
  type        = string
}

variable "instance_type" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "ssh_allow_ingress_list" {
  type = list(string)
}