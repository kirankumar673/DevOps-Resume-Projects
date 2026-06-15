provider "aws" {
  region = var.aws_region
}

resource "aws_security_group" "web" {
  name = "web-sg"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = "t2.micro"

  vpc_security_group_ids = [
    aws_security_group.web.id
  ]

  user_data = file("user-data.sh")
}
