variable "region" {
        default = "ap-south-1"
}

variable "az1" {
  default = ["ap-south-1a"]
}
variable "vpc_name" {
  default = "cbz-vpc"
}

variable "vpc-cidr" {
  default ="10.10.0.0/16"
}


variable "env" {
  default = "dev"
}


variable "pri_sub_cidr" {
  default ="10.10.0.0/20"
}


variable "subnet_name" {
  default = "cbz_private_sub"
}


variable "project" {
  default = "cbz"
}


variable "pub_sub_cidr" {
  default ="10.10.16.0/20"
}


variable "image_id" {
  default ="ami-0e670eb768a5fc3d4"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_pair" {
  default = "teraform.ky"
}