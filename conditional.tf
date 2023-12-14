provider "aws" {
    region = "eu-west-2"
  
}

locals {
    common_tags = {
        Owner = "DevOps mfs"
        service = "Backend"
    }
}

variable  "istest" {}


resource "aws_instance" "dev" {
    ami = "ami-0cfd0973db26b893b"
    instance_type = "t2.micro"
    tags = local.common_tags
    count = var.istest == true ? 1:0
}

resource "aws_instance" "prod" {
    ami = "ami-0cfd0973db26b893b"
    instance_type = "t2.micro"
    tags = local.common_tags
    count = var.istest == false ? 1:0
}