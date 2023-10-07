resource "aws_instance" "webservers" {
  count         = var.pubinstancecount                                        #length(aws_subnet.public-subnet.*.id)
  ami           = var.amiid
  instance_type = var.machinetype
  subnet_id     = element(var.instance-pub-subnet,count.index)
  key_name      = var.keyname
  vpc_security_group_ids = var.instance-vpcSG-id
  user_data = file("install_httpd.sh")
  tags = {
    Name = "public-server-${count.index+1}"
    env = var.env
  }
}

resource "aws_instance" "DB-servers" {
  count         = var.privateinstancecount                                        #length(aws_subnet.public-subnet.*.id)
  ami           = var.amiid
  instance_type = var.machinetype
  subnet_id     = element(var.instance-private-subnet,count.index)
  key_name      = var.keyname
  vpc_security_group_ids = var.instance-vpcSG-id
  user_data = file("install_httpd.sh")
  tags = {
    Name = "private-server-${count.index+1}"
    env = var.env
  }
}
