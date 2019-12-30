resource "aws_vpc" "new_cops_vpc" {
  cidr_block           = "${var.cidr}"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    KubernetesCluster                           = "${var.cluster_name}"
    Name                                        = "${var.cluster_name}"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

resource "aws_internet_gateway" "new_cops_gateway" {
  vpc_id = "${aws_vpc.new_cops_vpc.id}"

  tags = {
    KubernetesCluster                           = "${var.cluster_name}"
    Name                                        = "${var.cluster_name}"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

resource "aws_subnet" "1_azs" {
  vpc_id            = "${aws_vpc.new_cops_vpc.id}"
  cidr_block        = "${element(var.subnets, 0)}"
  availability_zone = "${element(var.azs, 0)}"
  map_public_ip_on_launch = true

  tags = {
    KubernetesCluster                           = "${var.cluster_name}"
    Name                                        = "${element(var.azs, 0)}.${var.cluster_name}"
    SubnetType                                  = "Public"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    "kubernetes.io/role/elb"                    = "1"
  }
}

resource "aws_vpc_dhcp_options" "dhcp_vpc_kops_new" {
  domain_name         = "${var.region}.compute.internal"
  domain_name_servers = ["AmazonProvidedDNS"]

  tags = {
    KubernetesCluster                           = "${var.cluster_name}"
    Name                                        = "${var.cluster_name}"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

resource "aws_vpc_dhcp_options_association" "dhcp_vpc_kops_new_ass" {
  vpc_id          = "${aws_vpc.new_cops_vpc.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.dhcp_vpc_kops_new.id}"
}

resource "aws_route" "0-0-0-0--0" {
  route_table_id         = "${aws_route_table.kops_route.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.new_cops_gateway.id}"
}

resource "aws_route_table" "kops_route" {
  vpc_id = "${aws_vpc.new_cops_vpc.id}"

  tags = {
    KubernetesCluster                           = "${var.cluster_name}"
    Name                                        = "${var.cluster_name}"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    "kubernetes.io/kops/role"                   = "public"
  }
}

resource "aws_route_table_association" "aws_route_table_association_1" {
  subnet_id      = "${aws_subnet.1_azs.id}"
  route_table_id = "${aws_route_table.kops_route.id}"
}
