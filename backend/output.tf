output "region" {
  value = "${var.region}"
}

output "cluster_name" {
  value = "${var.cluster_name}"
}

output "vpc_cidr_block" {
  value = "${var.cidr}"
}

output "subnets_cidr" {
  value = "${var.subnets}"
}

output "availability_zones" {
  value = "${var.azs}"
}
output "vpc_id" {
  value = "${aws_vpc.new_cops_vpc.id}"
}
output "subnets_ids" { 
  value = ["${aws_subnet.1_azs.id}"]
}
output "node_size" { 
  value = "${var.node_size}"
}
output "master_size" { 
  value = "${var.master_size}"
}
output "kub_ver" { 
  value = "${var.kub_ver}"
}
output "node_q" {
  value = "${var.node_q}" 
}
output "network_p" { 
  value = "${var.network_p}"
}
output "image" {
  value = "${var.image}" 
}
output "api_a" {
  value = "${var.api_a}"  
}
output "ssh_a" { 
  value = "${var.ssh_a}"  
}