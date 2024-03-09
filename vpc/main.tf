terraform {
  backend "s3" {
    bucket = "terraform-backup-mumbai"
    region = "ap-south-1"
    key = "terraform.tfstate"

  }
}

provider "aws" {
    region = var.region
}

resource "aws_vpc" "my_vpc" {
 name =var.vpc_name 
 cidr_block = var.vpc-cidr
 tags = {
   name = "cbz-vpc"
   env = "var.env"
 }
}

resource "aws_subnet" "pri_subnet" {
   vpc_id = aws_vpc.my_vpc
   cidr_block = var.pri_sub_cidr
   availability_zone = var.az1
   tags = {
    name = "${var.project}- private-subnet"
    env = var.env
   }
}

  
resource "aws_subnet" "pub_subnet" {
   vpc_id = aws_vpc.my_vpc
   cidr_block = var.pub_sub_cidr
   availability_zone = var.az2
   tags = {
    name = "${var.project}- public-subnet"
    env = var.env
   }
   map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "my-igw" {
  vpc_id = aws_vpc.my_vpc
  tags = {
    name = "${var.project}-igw"
    env = var.env
  }
}

resource "aws_default_route_table" "main-rt" {
  default_route_table_id = aws_vpc.my_vpc.default_route_table_id

  route {
    cidr block = ["0.0.0.0/0"]
    gateway_id = aws_internet_gateway.my-igw.id
  } 
 tags = {
    name = "${var.project}-rt"
    env = var.env
 } 


resource "aws_security_group" "sg1" {
    name =  "${var.project}-sg1 "
  vpc_id = aws_vpc.my_vpc.id
  description = "allow http service"
}

ingress {
    protocol = "tcp"
    from_port = 80
    to_port = 80
    cidr_block ["0.0.0.0/0"]
}

ingress {
    protocol = "tcp"
    from_port = 443
    to_port = 443
    cidr_block ["0.0.0.0/0"]
}
 
   egress {
        cidr_blocks = ["0.0.0.0/0"]
        protocol = "-1"
        from_port = 0
        to_port = 0
   }
   depends_on = [aws_vpc.my_vpc]
}
 
 resource " aws_instance" "instance-1" {
    ami = var.image_id
    instace_type = var.instance_type
    vpc_security_ids = [aws_vpc.my_vpc.default_security_group_id,aws_security_group.sg1.id]
    subnet_id = aws_subnet.pri_subnet.id
    key_name = var.key_pair
    tags = {
        name = "${var.project}-private-instance"
        env =var.env
    }

 }

resource " aws_instance" "instance-1" {
    ami = var.image_id
    instace_type = var.instance_type
    vpc_security_ids = [aws_vpc.my_vpc.default_security_group_id,aws_security_group.sg1.id]
    subnet_id = aws_subnet.pri_subnet.id
    key_name = var.key_pair
    tags = {
        name = "${var.project}-private-instance"
        env =var.env
    }
}

resource " aws_instance" "instance-2" {
    ami = var.image_id
    instace_type = var.instance_type
    vpc_security_ids = [aws_vpc.my_vpc.default_security_group_id,aws_security_group.sg1.id]
    subnet_id = aws_subnet.pub_subnet.id
    key_name = var.key_pair
    tags = {
        name = "${var.project}-public-instance"
        env =var.env
    }
    userdata = <<EOT
    #!/bin/bash
    yum install httpd -y
    systemctl start httpd
    systemctl enable httpd
    echo "<h1>" hello world " > /var/www/html/index.html
    EOT>>
    depends_on = [aws_security-group.sg1]
}