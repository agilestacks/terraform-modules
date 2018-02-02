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

variable "min_ttl" {
  type = "string"
  description = "Cache behaviour min TTL (0 default)"
  default = "0"
}

variable "default_ttl" {
  type = "string"
  description = "Cache behaviour default TTL (1d default)"
  default = "86400"
}

variable "max_ttl" {
  type = "string"
  description = "Cache behaviour max TTL (1y default)"
  default = "31536000"
}
