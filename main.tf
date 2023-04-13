provider "aws" {
  region = "us-west-2" 
}
resource "aws_instance" "splunk_SH" {
  ami           = "ami-0b5cb59327b8d7e1f" # us-west-2 AMI for Splunk
  instance_type = "t3.micro" # Update to t3.large in prod
  associate_public_ip_address = true
  vpc_security_group_ids = ["${aws_security_group.splunk_server.id}"]
  subnet_id              = "${aws_subnet.splunk_server.id}"
 
  #provisioner "local-exec" {
  # source="path\to\script\script.sh" #install app
  # destination="/tmp/script.sh" #AMI destination for install
  # command = "/bin/bash /tmp/script.sh" #executes script on destination
}

resource "aws_instance" "splunk_IDX1" {
  ami           = "ami-0b5cb59327b8d7e1f" # us-west-2 AMI for Splunk
  instance_type = "t3.micro" # Update to t3.large in prod
  associate_public_ip_address = true
  vpc_security_group_ids = ["${aws_security_group.splunk_server.id}"]
  subnet_id              = "${aws_subnet.splunk_server.id}"
  
  tags = {
    Name = "splunk-server"
  }
}

resource "aws_instance" "splunk_IDX2" {
  ami           = "ami-0b5cb59327b8d7e1f" # us-west-2 AMI for Splunk
  instance_type = "t3.micro" # Update to t3.large in prod
  associate_public_ip_address = true
  vpc_security_group_ids = ["${aws_security_group.splunk_server.id}"]
  subnet_id              = "${aws_subnet.splunk_server.id}"
  
  tags = {
    Name = "splunk-server"
  }
}

resource "aws_instance" "splunk_mgmt" {
  ami           = "ami-0b5cb59327b8d7e1f" # us-west-2 AMI for Splunk
  instance_type = "t3.micro" # Update to t3.medium in prod
  associate_public_ip_address = true
  vpc_security_group_ids = ["${aws_security_group.splunk_server.id}"]
  subnet_id              = "${aws_subnet.splunk_server.id}"
  
  tags = {
    Name = "splunk-server"
  }

}

resource "aws_security_group" "splunk_server" {
  name_prefix = "splunk-group"
  
  ingress {
    from_port   = 22 # ssh port
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["<ip-address>"]
  }

  ingress {
    from_port   = 8000 # Web UI port
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["<ip-address>"]
  }

  ingress {
    from_port   = 8088 # HEC port
    to_port     = 8088
    protocol    = "tcp"
    cidr_blocks = ["<ip-address>"]
  }

  ingress {
    from_port   = 9997 # Forwarder port
    to_port     = 9997
    protocol    = "tcp"
    cidr_blocks = ["<ip-address>"]
  }
  
  tags = {
    Name = "splunk-server"
  }
}

resource "aws_subnet" "splunk_server" {
  vpc_id = "vpc-002c2876364b2b282"
  cidr_block = "172.31.1.0/28" 
}

output "splunk_server_public_ip" {
  value = "${aws_instance.splunk_SH.public_ip}"
  description = "The public IP of the Splunk server"
}