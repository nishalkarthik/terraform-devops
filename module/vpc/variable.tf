variable "vpc-cidr" {
  description = "this is vpc cidr block"
  type = string
}

variable "vpctag" {
  description = "vpctag"
  type = object({
    Name = string
    Env = string
  })
}

variable "public-subentcidr" {
  type = list(string)
  description = "this is public subnets-cidr blocks"
}

variable "AZ-public" {
  type        = list(string)
  description = "this is availability zones for public subnet"
}

variable "AZ-private" {
  type = string
  description = "this is availability zones for private subnet"
}
variable "env" {
  description = "environment"
  type = string
}

variable "private-subentcidr" {
  type = string
  description = "this is private subnets-cidr blocks"
}

variable "cidr-block" {
  description = "this is the cidr block for sg-rules & rt-rules"
  type = string
}
