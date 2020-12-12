# Create an EC2 instance
resource "aws_instance" "lab_iaas1" {
  ami = "${lookup(var.amis,var.region)}"
  count = "${var.az_count}"
  #key_name = "${var.key_name}"
  key_name = "${aws_key_pair.lab_kp.key_name}"
  vpc_security_group_ids = ["${aws_security_group.lab_sg_instance.id}"]
  source_dest_check = false
  instance_type = "t2.micro"

  tags = {
    Name = "${format("web-%03d", count.index + 1)}"
  }
}

# Create security group for EC2
resource "aws_security_group" "lab_sg_instance" {
  name = "terraform-instance"
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create the key pair
resource "aws_key_pair" "lab_kp" {
  key_name = "${var.key_name}"
  #public_key = "${file("~/.ssh/aws_labs.pub")}"
  public_key = "${file("${var.public_key_path}")}"
}

