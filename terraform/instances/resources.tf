resource "aws_instance" "node" {
  ami             = "${data.aws_ami.ubuntu.id}"
  instance_type   = "t2.micro"
  # count           = 3

  tags = {
    Name = "node"
  }
}