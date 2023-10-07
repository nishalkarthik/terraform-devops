output "vpc-id" {
  value = aws_vpc.global-vpc.id
}

output "pub-subnet" {
  value = aws_subnet.public-subnet.*.id
}

output "private-subnet" {
  value = aws_subnet.private-subnet.*.id
}

output "asgzonesubnet1" {
  value = aws_subnet.public-subnet[0].id
}

output "asgzonesubent2" {
  value = aws_subnet.public-subnet[1].id
}