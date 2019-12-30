data "aws_route53_zone" "parent" {
  zone_id = "ZXYX1PMCE4AO8"
}

resource "aws_route53_zone" "cluster" {
  name = "${var.cluster_name}"
}

resource "aws_route53_record" "parent" {
  allow_overwrite = true
  name            = "${var.cluster_name}"
  ttl             = 300
  type            = "NS"
  zone_id         = "${data.aws_route53_zone.parent.zone_id}"

  records = [
    "${aws_route53_zone.cluster.name_servers.0}",
    "${aws_route53_zone.cluster.name_servers.1}",
    "${aws_route53_zone.cluster.name_servers.2}",
    "${aws_route53_zone.cluster.name_servers.3}",
  ]
}
