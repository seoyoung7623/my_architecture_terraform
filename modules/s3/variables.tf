variable "stage" {
  type = string
}

variable "servicename" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "frontend_bucket" {
    description = "The bucket name"
    type        = string
}