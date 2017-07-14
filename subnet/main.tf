
variable "vpc_id" {}

variable "name" {
  default = "private"
}

variable "cidr_block" {
  default = "10.0.1.0/24"
}

variable "availability_zone" {
  default = ""
}

data "aws_vpc" "selected" {
  id = "${var.vpc_id}"
}

resource "aws_subnet" "main" {
  vpc_id     = "${data.aws_vpc.selected.id}"
  cidr_block = "${var.cidr_block}"
  availability_zone = "${var.availability_zone}"
  tags {
    Name = "${var.name}"
  }
}

output "subnet_id" {
  value = "${aws_subnet.main.id}"
}