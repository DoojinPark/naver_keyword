provider "aws" {
    region = "ap-northeast-2"
}
resource "null_resource" "crawling_naver_keyword" {
    connection {
        host        = "52.78.213.207"
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
}
