output "bucket" {
  value = "${aws_s3_bucket.main.bucket}"
}

output "website_domain" {
  value = "${aws_s3_bucket.main.website_domain}"
}

output "website_endpoint" {
  value = "${aws_s3_bucket.main.website_endpoint}"
}

output "hosted_zone_id" {
  value = "${aws_s3_bucket.main.hosted_zone_id}"
}

output "bucket_domain_name" {
  value = "${aws_s3_bucket.main.bucket_domain_name}"
}
