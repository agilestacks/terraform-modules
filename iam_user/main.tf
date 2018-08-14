
variable "username" {
  type = "string"
  description = "IAM user name"
}

variable "path" {
  type = "string"
  description = "IAM user path"
  default = "/system/"
}

variable "policy" {
  type = "string"
  default =<<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_user" "main" {
  name = "${var.username}"
  path = "${var.path}"
  force_destroy = true
}

resource "aws_iam_access_key" "main" {
  user    = "${aws_iam_user.main.name}"
}

resource "aws_iam_user_policy" "s3write" {
  name_prefix  = "argo"
  user = "${var.username}"
  policy = "${var.policy}"
}

output "access_key_id" {
  value = "${aws_iam_access_key.main.id}"
}

output "secret_access_key" {
  value = "${aws_iam_access_key.main.secret}"
}
