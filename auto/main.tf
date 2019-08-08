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
    connection {
        host        = "${self.public_ip}"
        user        = "ubuntu"
        type        = "ssh"
        private_key = "${file("~/.ssh/dss_key")}"
        timeout     = "1m"
    }
    provisioner "remote-exec" {
        inline = [
			"sudo apt-get update",
			"sudo apt install python3",
            "sudo apt-get install -y python3-pip",
            "sudo apt-get install -y libmysqlclient-dev",
            "git clone https://github.com/DoojinPark/naver_keyword.git",
            "pip3 install -r ~/naver_keyword/requirements.txt",
            "python3 ~/naver_keyword/naver_keywords.py"
        ]
    }
    tags = {
      Name = "dss_crwaling"
    }
}
