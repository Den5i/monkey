resource "aws_instance" "node" {
  ami             = "${data.aws_ami.ubuntu.id}"
  instance_type   = "${var.instance_type}"
  count           = "${var.instance_count}"

  tags = {
    Name = "node"
  }
}

resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}


resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.default.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.default.id}"
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
}


resource "aws_subnet" "default" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_security_group" "default" {
  name        = "chef"
  description = "Used in the terraform"
  vpc_id      = "${aws_vpc.default.id}"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from the VPC
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "template_file" "chef_userdata" {
  template = "${file("chef_userdata.tpl")}"

  vars = {
    domain_name = "${var.domain_name}"
  }
}

resource "template_file" "chef_bootstrap" {
  template = "${file("chef_bootstrap.tpl")}"

  vars = {
    chef_username = "${var.chef_username}"
    chef_user = "${var.chef_user}"
    chef_password = "${var.chef_pwd}"
    chef_user_email = "${var.chef_user_email}"
    chef_organization_id = "${var.chef_organization_id}"
    chef_organization_name = "${var.chef_organization_name}"
  }
}

resource "aws_instance" "chef" {
  instance_type          = "${var.instance_type}"
  ami                    = "${data.aws_ami.ubuntu.id}"
  subnet_id              = "${aws_subnet.default.id}"
  vpc_security_group_ids = ["${aws_security_group.default.id}", "${aws_security_group.default.id}"]

  tags = {
      Name = "chef"
  }

  provisioner "remote-exec" {
    inline = [
      "echo '${template_file.chef_bootstrap.rendered}' > /tmp/bootstrap-chef-server.sh",
      "chmod +x /tmp/bootstrap-chef-server.sh",
      "sudo sh /tmp/bootstrap-chef-server.sh"
    ]
  }

  user_data = "${template_file.chef_userdata.rendered}"
}
