resource "aws_instance" "master" {
  ami             = "${data.aws_ami.ubuntu.id}"
  instance_type   = "t2.micro"

  tags = {
    Name = "master"
  }
}