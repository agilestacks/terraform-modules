variable "elb" {
  description = "Fully qualified domain name of the ELB"
}

variable "retry" {
  default = "10"
}

locals {
  elb_name = "${element(split("-", element(split(".", "${var.elb}"), 0)), 0)}"
}

data "aws_region" "current" {}

resource "null_resource" "drop_elb" {
  provisioner "local-exec" {
    when       = "destroy"
    on_failure = "continue"

    command = <<EOF
export AWS_DEFAULT_REGION="${data.aws_region.current.name}"
SG_IDS=$(aws \
  elb describe-load-balancers \
  --load-balancer-names ${local.elb_name} --query 'LoadBalancerDescriptions[*].SecurityGroups[*]' --output=text \
  | xargs)

echo "Delete ELB ${local.elb_name}"
aws \
  elb delete-load-balancer  \
  --load-balancer-name=${local.elb_name}

for ID in "$SG_IDS"; do
  echo "Proceed with SG cleanup: $ID"
  SG_REVOKES=$(aws \
      ec2 describe-security-groups \
      --query "SecurityGroups[?contains(IpPermissions[].UserIdGroupPairs[].GroupId,'$ID')].GroupId" \
      --output=text | xargs )
  echo "Revoking ingress from: $SG_REVOKES"
  for R in "$SG_REVOKES"; do
    echo "Proceed revoke $R ingress route source: $ID"
    aws \
      ec2 revoke-security-group-ingress \
      --group-id "$R" --source-group "$ID" --protocol all;
  done;

  echo "Delete SG $ID"
  for n in $(seq 18); do
    aws \
      ec2 delete-security-group \
      --group-id="$ID" \
    && break;
    echo "Retry $n in ${var.retry}sec..."
    sleep ${var.retry}
  done
done
EOF
  }
}
