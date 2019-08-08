provider "aws" {
    region = "ap-northeast-2"
}

resource "aws_instance" "dss-ec2" {
    ami = "ami-0fd02cb7da42ee5e0"
    instance_type = "t2.nano"
    key_name = "dss_key"
    vpc_security_group_ids = [
        "sg-0ea15d10693e08b90"
    ]
    provisioner "local-exec" {
        command = "echo ${aws_instance.dss-ec2.public_ip} > public_ip.txt"
    }
    tags = {
        Name = "dss_crawling"
    }
}
