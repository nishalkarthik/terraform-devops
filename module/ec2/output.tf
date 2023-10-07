output "webserver_ids"{
 value = aws_instance.webservers.*.id
}

output "asginstanceid" {
 value = aws_instance.webservers[0].id
}

