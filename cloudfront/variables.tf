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
