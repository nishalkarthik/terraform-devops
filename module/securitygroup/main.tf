resource "aws_security_group" "vpc-sg" {
  name = var.sgname
  vpc_id = var.sg-vpc-id
  description = "Allow ssh http"

  ingress {
    description = "ssh"
    protocol = "tcp"
    from_port = 22
    to_port = 22
    cidr_blocks = [var.cidr-block]
  }

  ingress {
    description = "http"
    protocol = "tcp"
    from_port = 80
    to_port = 80
    cidr_blocks = [var.cidr-block]
  }
  ingress {
    description = "https"
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = [var.cidr-block]
  }
  egress {
    description = "all traffic"
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = [var.cidr-block]
  }
  tags = {
    Name = var.sgname
    env = var.env
  }
}

