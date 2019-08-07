provider "aws" {
  region = "eu-west-1"
  profile = "dev"
}


resource "aws_security_group" "allow_nginx" {
  name = "allow nginx"
  description = "allow nginx"
  vpc_id = "vpc-801628e7"

ingress {
    from_port   = 22 
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["143.65.196.4/32"] # add a CIDR block here
  }

  ingress {
    from_port   = 80 
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["143.65.196.4/32"] # add a CIDR block here
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow_jenkins" {
  name = "allow jenkins"
  description = "allow jenkins"
  vpc_id = "vpc-801628e7"

ingress {
    from_port   = 22 
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["143.65.196.4/32"] # add a CIDR block here
  }

  ingress {
    from_port   = 8080 
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["143.65.196.4/32"] # add a CIDR block here
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "nginx" {
  ami           = "ami-03746875d916becc0"
  instance_type = "t2.micro"

  subnet_id = "subnet-55c5f21c"

  associate_public_ip_address = "true"

  key_name = "TaslimaTestKey"

  vpc_security_group_ids = ["${aws_security_group.allow_nginx.id}"]

  provisioner "local-exec" {
    command = "sleep 50;ansible-playbook -i ${aws_instance.nginx.public_ip}, playbook.yml  -u ubuntu --key-file /home/siddiq08/TaslimaTestKey.pem"
  }
}

resource "aws_instance" "jenkins" {
  ami           = "ami-03746875d916becc0"
  instance_type = "t2.micro"

  subnet_id = "subnet-55c5f21c"

  associate_public_ip_address = "true"

  key_name = "TaslimaTestKey"

  vpc_security_group_ids = ["${aws_security_group.allow_jenkins.id}"]

  provisioner "local-exec" {
    command = "sleep 50;ansible-playbook -i ${aws_instance.jenkins.public_ip}, playbook.yml  -u ubuntu --key-file /home/siddiq08/TaslimaTestKey.pem"
  }
}