output "instance_ips" {
  value = aws_instance.lab_iaas1.*.public_ip
}

output "elb_dns_names" {
  value = "${aws_elb.lab_elb.*.dns_name}"
}
