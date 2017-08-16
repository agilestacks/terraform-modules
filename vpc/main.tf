resource "aws_vpc" "main" {
    cidr_block = "${var.cidr_block}"

    enable_dns_support = true
    enable_dns_hostnames = true

    tags {
        Name = "${var.name}"
    }
}

resource "aws_internet_gateway" "main" {
    vpc_id = "${aws_vpc.main.id}"

    tags {
        Name = "${var.name}"
    }
}

resource "aws_subnet" "public" {
    vpc_id = "${aws_vpc.main.id}"
    map_public_ip_on_launch = "${var.assign_public_ip}"
    availability_zone = "${var.availability_zone}"
    cidr_block        = "${cidrsubnet(aws_vpc.main.cidr_block, 8, 1)}"
    tags {
        Name = "${var.name}"
    }

    provisioner "local-exec" {
        when       = "destroy"
        on_failure = "continue"
        command = <<END
export AWS_DEFAULT_OUTPUT="json"
export SUBNET_ID=${this.id}

ELB_DATA=$(
  aws elb describe-load-balancers | jq -Mr '.LoadBalancerDescriptions[] | [{Subnets: .Subnets,  LoadBalancerName: .LoadBalancerName, SecurityGroups: .SecurityGroups}]  | select(.[].Subnets[] | contains("'$SUBNET_ID'"))'
)

for ELB_NAME in $(echo $ELB_DATA | jq -Mr .[].LoadBalancerName | xargs); do
  echo "Delete ELB $ELB_NAME"
  aws elb delete-load-balancer --load-balancer-name $ELB_NAME
done
echo "Wait for completion"
sleep 15

for GROUP_ID in $(echo ${ELB_DATA} | jq -Mr .[].SecurityGroups[] | xargs); do
  echo "Delete Security Group $GROUP_ID"
  echo aws ec2 delete-security-group --group-id $GROUP_ID | true
done
echo "Wait for completion"
sleep 15
echo "Done"

END
    }
}

resource "aws_route_table" "r" {
    vpc_id = "${aws_vpc.main.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.main.id}"
    }

    tags {
        Name = "${var.name}"
    }
}

resource "aws_main_route_table_association" "a" {
    vpc_id = "${aws_vpc.main.id}"
    route_table_id = "${aws_route_table.r.id}"
}

# resource "aws_vpc_dhcp_options_association" "dns_resolver" {
#     vpc_id = "${aws_vpc.main.id}"
#     dhcp_options_id = "${aws_vpc_dhcp_options.main.id}"
# }

# resource "aws_vpc_dhcp_options" "main" {
#     domain_name = "${var.domain_name}"
#     domain_name_servers = ["${var.dns_servers}"]
#     ntp_servers = ["127.0.0.1"]
#     netbios_name_servers = ["127.0.0.1"]
#     netbios_node_type = 2

#     tags {
#         Name = "${var.name}"
#     }
# }

resource "aws_default_security_group" "default" {
  ingress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      self = true
  }

  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "default-${var.name}"
  }
}