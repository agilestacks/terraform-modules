variable "availability_zone" {
  type = "string"
  description = "primary availability zone"
}

data "aws_availability_zones" "available" {
  state = "available"
}

output "zone" {
  value = "${element(compact(split(",", replace(join(",", "${data.aws_availability_zones.available.names}"), "${var.availability_zone}", ""))), 0)}"
}

output "zone1" {
  value = "${element(compact(split(",", replace(join(",", "${data.aws_availability_zones.available.names}"), "${var.availability_zone}", ""))), 0)}"
}

output "zone2" {
  value = "${element(compact(split(",", replace(join(",", "${data.aws_availability_zones.available.names}"), "${var.availability_zone}", ""))), 1)}"
}