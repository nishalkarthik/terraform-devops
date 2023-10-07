vpc-cidr = "11.0.0.0/20"

vpctag = {
  Name = "vpc-prod"
  Env = "production"
  version = 1.0
}
public-subentcidr = ["11.0.1.0/24","11.0.2.0/24"]

private-subentcidr = "11.0.3.0/24"

AZ-public = ["us-west-2a","us-west-2b"]

AZ-private = "us-west-2a"

env = "production"

cidr-block = "0.0.0.0/0"

sgname = "dev-vpcSG"

amiid = "ami-0f3769c8d8429942f"

machinetype = "t2.micro"

keyname = "MyLinuxWeb"

publicinstancecount = 2

privateinstancecount = 1

/*
instance-vpcSG-id = [module.aws_sg.sg-vpc-id]

instance-pub-subnet = module.aws_vpc.pub-subnet

sg-vpc-id = module.aws_vpc.vpc-id*/

name = "default-env"

alb-tag = {
  Name = "alb"
  Env = "default"
}

launchtemplate-asg-AZs = ["us-west-2a","us-west-2b","us-west-2c","us-west-2d"]

desiredcap = 2
mincap = 1
maxcap = 4
cputargetval = 10