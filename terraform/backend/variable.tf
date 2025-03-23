variable "s3_bucket_name" {
  type = string
  default = "seoyoung-terraform-state-s3"
}

variable "dynamoDB_table_name" {
  type = string
  default = "seoyoung-terraform-state-lock"
  
}