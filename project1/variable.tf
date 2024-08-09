variable "publicinstancecount" {
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

variable "privateinstancecount" {
  type = number
}

/*
variable "instance-private-subnet" {
  type = list(string)
}
*/

/*
variable "instance-pub-subnet" {
  type = list(string)
}

variable "instance-vpcSG-id" {
  type = list(string)
}
*/

variable "env" {
  description = "environment"
  type = string
}

variable "cidr-block" {
  description = "this is the cidr block for sg-rules & rt-rules"
  type = string
}

variable "sgname" {
  type = string
}


/*variable "sg-vpc-id" {
  type = string
}*/

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


variable "private-subentcidr" {
  type = string
  description = "this is private subnets-cidr blocks"
}


variable "alb-tag" {
  description = "alb-tg"
  type = object({
    Name = string
    Env = string
  })
}

variable "name" {
  type = string
}


variable "launchtemplate-asg-AZs" {
  type = list(string)
}



variable "desiredcap" {
  type = string
}

variable "maxcap" {
  type = string
}

variable "mincap" {
  type = string
}

variable "cputargetval" {
  type = number
}

