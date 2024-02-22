
provider  "aws"  {
    region = "ca-central-1b"
}

resource "aws_instance" "my_instance" {
    ami = "ami-0156b61643fdfee5c"
    instance_type = "t2.micro"
    key_name = "canada.ky"
    tags = {
      env = "dev"
      name = "instance_1"
      vpc_security_group_ids = ["sg-0f75e427e52c76d89"] 
    }
}  