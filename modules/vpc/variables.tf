#Comm TAG
variable "tags" {
  type = map(string)
}

variable "stage" {
  type = string
}

variable "servicename" {
  type = string
}

#VPC
variable "az" {
  type = list(any)
}

variable "vpc_cidr" {
  type = string
}