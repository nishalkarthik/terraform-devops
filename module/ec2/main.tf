resource "aws_instance" "webservers" {
  count         = var.pubinstancecount                                        #length(aws_subnet.public-subnet.*.id)
  ami           = var.amiid
  instance_type = var.machinetype
  subnet_id     = element(var.instance-pub-subnet,count.index)            # element(list,index)---list,it looks for the list of string [list(string)] for where we need to get the element/values and index tells which particular it needs to take from the list eg: 0,1,2.....
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
