variable "name" {
    default = ""
}

variable "r53_zone_id" {}

variable "r53_domain" {
    default = ""
}

variable "type" {
	default = "CNAME"
}

variable "records" {
	type = "list"
}

variable "ttl" {
  type = "string"
  description = "Time to live in seconds"
  default = "30"
}

variable "prevent_destroy" {
  description = "true or false"
  default = false
}

variable "identifier" {
  type = "string"
  description = "Set identifier for route53 record. Useful for failover routing"
  default = ""
}

# variable "record" {
# 	default = ""
# }

# variable "record0" {
# 	default = ""
# }

# variable "record1" {
# 	default = ""
# }

# variable "record2" {
# 	default = ""
# }

# variable "record3" {
# 	default = ""
# }

# variable "record4" {
# 	default = ""
# }

# variable "record5" {
# 	default = ""
# }

# variable "record6" {
# 	default = ""
# }

# variable "record7" {
# 	default = ""
# }

# variable "record8" {
# 	default = ""
# }
