variable "cidr-block" {
  description = "this is the cidr block for sg-rules & rt-rules"
  type = string
}

variable "sgname" {
  type = string
}

variable "env" {
  description = "environment"
  type = string
}

variable "sg-vpc-id" {
  type = string
}