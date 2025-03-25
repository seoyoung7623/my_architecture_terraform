variable "stage" {
  type = string
}

variable "servicename" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "internal" {
  type = bool
}

variable "subnet_ids" {
  type = list(any)
}

variable "idle_timeout" {
  type    = number
  default = 60
}

variable "vpc_id" {
  type = string
}

variable "aws_s3_lb_logs_name" {
  type = string
}

# Health Check
variable "port" {
  type = number
}

variable "target_type" {
  type = string
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