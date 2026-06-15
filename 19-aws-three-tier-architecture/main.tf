resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_lb" "alb" {
  name               = "three-tier-alb"
  load_balancer_type = "application"
}

resource "aws_db_instance" "mysql" {
  allocated_storage = 20
  engine            = "mysql"
  instance_class    = "db.t3.micro"
}
