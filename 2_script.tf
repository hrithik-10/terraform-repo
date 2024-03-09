terraform {
  backend "s3" {
    bucket = "terraform-backup-mumbai"
    region = "ap-south-1"
    key = "terraform.tfstate"

  }
}

provider "aws" {
    region = "ap-south-1"
}

resource "aws_instance" "my_instance" {
    ami = "ami-0e670eb768a5fc3d4"
    instance_type = var.instance_type
    key_name = var.key_name
    tags = {
        env = "dev"
        Name = "instance-2"
    }
    vpc_security_group_ids = ["sg-0465b2648fc3cac08"]

}
 
 

 variable "instance_type" {
    description = "instance_type"
    default = "t2.micro"
 }

 variable "key_name" {
  description = "key_pair"
    default = "teraform.ky"
 }