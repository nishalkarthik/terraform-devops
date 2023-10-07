/*module "ec2_instance" {
  source = "../module/ec2"

  pubinstancecount = var.publicinstancecount
  privateinstancecount = var.privateinstancecount
  amiid = var.amiid
  machinetype = var.machinetype
  instance-pub-subnet = module.aws_vpc.pub-subnet
  instance-private-subnet = module.aws_vpc.private-subnet
  keyname = var.keyname
  instance-vpcSG-id = [module.aws_sg.sg-vpc-id]
  env = var.env

}

module "aws_sg" {
  source = "../module/securitygroup"

  sgname = var.sgname
  sg-vpc-id = module.aws_vpc.vpc-id
  cidr-block = var.cidr-block
  env = var.env
}*/

module "aws_vpc" {
  source = "../module/vpc"

  vpc-cidr = var.vpc-cidr
  vpctag = var.vpctag
  public-subentcidr = var.public-subentcidr
  private-subentcidr = var.private-subentcidr
  AZ-public = var.AZ-public
  AZ-private = var.AZ-private
  cidr-block = var.cidr-block
  env = var.env
}
/*

module "aws_lb" {
  source = "../module/loadbalancer"

  name = var.name
  lb-sg = module.aws_sg.sg-vpc-id
  lb-pub-subnets = module.aws_vpc.pub-subnet
  alb-tag = var.alb-tag
  lb-vpcid = module.aws_vpc.vpc-id
  webservers = module.ec2_instance.webserver_ids
}

module "aws_ami-launchtemplate" {
  source = "../module/ami & launch_template"
  asginstanceid = module.ec2_instance.asginstanceid
  name = var.name
  machinetype = var.machinetype
  vpcsg-id = [module.aws_sg.sg-vpc-id]
  keyname = var.keyname
  */
/*launchtemplate-asg-AZs = var.launchtemplate-asg-AZs*//*

}

module "aws_asg" {
  source = "../module/asg"
  launchtemplateid = module.aws_ami-launchtemplate.launchtemplateid
  launchtemplate-asg-AZs = var.launchtemplate-asg-AZs
  asgzonesubnet1 = module.aws_vpc.asgzonesubnet1
  asgzonesubnet2 = module.aws_vpc.asgzonesubent2
  desiredcap = var.desiredcap
  maxcap = var.maxcap
  mincap = var.mincap
  cputargetval = var.cputargetval
  targetgrouparn = module.aws_lb.targetgrouparn
}


*/
