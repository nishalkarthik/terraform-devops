variable "launchtemplateid" {
  type = string
}

variable "desiredcap" {
  type = number
}

variable "maxcap" {
  type = number
}

variable "mincap" {
  type = number
}

variable "cputargetval" {
  type = number
}

variable "launchtemplate-asg-AZs" {
  type = list(string)
}

variable "targetgrouparn" {
  type = string
}

variable "asgzonesubnet1" {
  type = string
}

variable "asgzonesubnet2" {
  type = string
}