terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.23.1"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "foo" {
  ami                    = "ami-06791f9213cbb608b"
  instance_type          = "t2.micro"
  key_name               = "newkey"
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  user_data              = <<EOF
    #!/bin/bash
    sudo yum install nginx -y 
    sudo systemctl start nginx 
    sudo systemctl enable nginx
    EOF

  tags = {
    Name = "my_new"
  }
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}
