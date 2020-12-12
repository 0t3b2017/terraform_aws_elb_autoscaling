# Create the Launch Configuration
resource "aws_launch_configuration" "lab_lc" {
  #image_id              = "lookup(var.amis,var.region)"
  image_id              = "${lookup(var.amis,var.region)}"
  instance_type         = "t2.micro"
  #security_groups       = ["aws_security_group.lab_sg_instance.id"]
  security_groups       = ["${aws_security_group.lab_sg_instance.id}"]
  key_name              = aws_key_pair.lab_kp.key_name
  user_data             = <<-EOF
                          #!/bin/bash
                          echo "Hello AWS, by OTEB" > index.html
                          nohup busybox httpd -f -p 8080 &
                          EOF
  lifecycle {
    create_before_destroy = true
  }
}

## Create AutoScaling Group
resource "aws_autoscaling_group" "lab_asg" {
  launch_configuration = aws_launch_configuration.lab_lc.id
  availability_zones = "${data.aws_availability_zones.available.names}"
  min_size = 2
  max_size = 4
  load_balancers = "${aws_elb.lab_elb.*.name}"
  health_check_type = "ELB"
  tags = concat(
    [
      {
        key = "Name"
        value = "terraform-asg"
        propagate_at_launch = "true"
      }
    ]
  )
}

