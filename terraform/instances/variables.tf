# AWS Config

variable "aws_shared_credentials" {
  default = "/home/den/.aws/credentials"
}

variable "aws_region" {
  default = "eu-central-1"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "instance_count" {
  default = 1
}