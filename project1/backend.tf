# terraform {
#   backend "s3" {
#     bucket = "s3-myterraform"
#     key = "terraform.tfstate"
#     encrypt = true
#     region = "us-west-2"
#     dynamodb_table = "terras3"
#   }
# }