variable "pubinstancecount" {
  type = number
}

variable "privateinstancecount" {
  type = number
}
variable "amiid" {
  type = string
}

variable "machinetype" {
  type = string
}

variable "keyname" {
  type = string
}

variable "instance-pub-subnet" {
  type = list(string)
}

variable "instance-private-subnet" {
  type = list(string)
}

variable "instance-vpcSG-id" {
  type = list(string)
}


variable "env" {
  description = "environment"
  type = string
}
