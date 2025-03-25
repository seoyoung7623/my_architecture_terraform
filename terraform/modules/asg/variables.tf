variable "stage" {
    type  = string
}
variable "servicename" {
    type  = string
}
variable "tags" {
  type = map(string)
}

variable "asg-subnets" {
    type  = list 
}

variable "launch_template_id" {
    type  = string
}

variable "target_group_arn" {
  description = "ALB target group ARN"
  type        = string
}
