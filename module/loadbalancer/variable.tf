variable "name" {
  type = string
}

variable "lb-sg" {
  type = string
}

variable "lb-pub-subnets" {
  type = list(string)
}

variable "alb-tag" {
  description = "alb-tg"
  type = object({
    Name = string
    Env = string
  })
}

variable "lb-vpcid" {
  type = string
}

variable "webservers" {
  type = list(string)
}