resource "aws_instance" "node" {
  ami             = "${data.aws_ami.ubuntu.id}"
  instance_type   = "${data.aws_ami.instance_type}"
  count           = "${data.aws_ami.instance_count}"

  tags = {
    Name = "node"
  }
}