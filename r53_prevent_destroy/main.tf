resource "aws_route53_record" "main" {
  triggers {
    recs = "${join(",", var.records)}"
  }
  # depends_on = ["null_resource.uptime"]

  zone_id = "${var.r53_zone_id}"
  name    = "${join(".", compact(split(".", "${var.name}.${var.r53_domain}")))}"
  type    = "${var.type}"
  ttl     = "${var.ttl}"
  records = ["${var.records}"]
  lifecycle {
    ignore_changes = ["records", "ttl"]
    prevent_destroy = true
  }
}

# resource "null_resource" "uptime" {
#   triggers {
#     recs = "${join(",", var.records)}"
#   }
# }
