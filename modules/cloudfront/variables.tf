variable "stage" {
  type = string
}

variable "servicename" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "frontend_bucket_regional_domain_name" {
  type = string
}

variable "dev_domain_name" {
  type        = string
  description = "사용할 커스텀 도메인"
}
