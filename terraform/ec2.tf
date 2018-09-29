data "aws_vpc" "default" {
  cidr_block = "172.30.0.0/16"
}

data "aws_subnet_ids" "default_subnets" {
  vpc_id = "${data.aws_vpc.default.id}"
}

data "template_file" "web_cloud_config" {
  template = "${file("${path.module}/web-cloud-config")}"

  vars {
    repository_url = "${aws_ecr_repository.stratospike_web.repository_url}"
    allocation_id = "${aws_eip.stratospike_web.id}"
    region = "${var.region}"
  }
}

resource "aws_eip" "stratospike_web" {
  vpc = true
}

resource "aws_security_group" "vpc_web_server" {
  name = "vpc-webserver"
  description = "Allow inbound web traffic"

  vpc_id = "${data.aws_vpc.default.id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
}

resource "aws_iam_instance_profile" "stratospike_web" {
  name = "stratospike-web"
  role = "${aws_iam_role.stratospike_web.name}"
}

resource "aws_launch_configuration" "stratospike_web" {
  name_prefix = "stratospike-web-"
  image_id = "ami-19c0de60"
  instance_type = "t2.nano"
  key_name = "stratospike-web-primary"
  iam_instance_profile = "${aws_iam_instance_profile.stratospike_web.name}"
  security_groups = ["${aws_security_group.vpc_web_server.id}"]
  associate_public_ip_address = true
  user_data = "${data.template_file.web_cloud_config.rendered}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "stratospike-web" {
  name_prefix = "stratospike-web-"
  launch_configuration = "${aws_launch_configuration.stratospike_web.name}"
  vpc_zone_identifier = ["${data.aws_subnet_ids.default_subnets.ids}"]
  min_size = 0
  desired_capacity = 1
  max_size = 1

  lifecycle {
    create_before_destroy = true
  }
}
