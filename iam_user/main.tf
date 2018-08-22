
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

data "aws_region" "current" {}

resource "null_resource" "clenup_policies" {
  provisioner "local-exec" {
    when = "destroy"
    on_failure = "continue"

    command=<<EOF
#!/bin/bash
policies=$(aws --region="${data.aws_region.current.name}" iam list-user-policies --user-name "${aws_iam_user.main.name}" --query "PolicyNames[]" --output=
 | xargs)
for policy in "$policies"; do
  echo "Delete IAM policy: $policy"
  aws --region="${data.aws_region.current.name}" iam delete-user-policy --user-name="${aws_iam_user.main.name}" --policy-name="$policy"
done
EOF
  }
}

resource "aws_iam_user" "main" {
  name = "${var.username}"
  path = "${var.path}"
  force_destroy = true
}

resource "aws_iam_access_key" "main" {
  user    = "${aws_iam_user.main.name}"
}

resource "aws_iam_user_policy" "root" {
  name_prefix  = "argo"
  user = "${aws_iam_user.main.name}"
  policy = "${var.policy}"
}

output "arn" {
  value = "${aws_iam_user.main.arn}"
}

output "unique_id" {
  value = "${aws_iam_user.main.unique_id}"
}

output "access_key_id" {
  value = "${aws_iam_access_key.main.id}"
}

output "secret_access_key" {
  value = "${aws_iam_access_key.main.secret}"
}
