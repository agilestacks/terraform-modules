variable "s3_origin" {}

variable "s3_origin_domain_name" {
  type = "string"
  default = ""
}

variable "s3_logging" {
  type = "string"
  default = ""
}

variable "domain_names" {
	type = "list"
	default = []
}

variable "acm_certificate_arn" {
  type = "string"
  default = ""
}

variable "cloudfront_default_certificate" {
  type = "string"
  default = "false"
}

variable "viewer_protocol_policy" {
  type = "string"
  description = "One of allow-all, https-only, or redirect-to-https"
  default = "redirect-to-https"
}

# variable "domain_name" {
#   default = ""
# }

# variable "domain_name0" {
#   default = ""}

# variable "domain_name1" {
#   default = ""
# }

# variable "domain_name2" {
#   default = ""
# }

# variable "domain_name3" {
#   default = ""
# }
