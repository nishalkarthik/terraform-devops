#! /bin/bash

sudo yum install httpd -y
sudo systemctl start httpd
sudo systemctl enable httpd
sudo echo "this a done using terraform" > /var/www/html/index.html