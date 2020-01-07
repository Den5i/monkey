provider "aws" {
  shared_credentials_file = "${var.aws_shared_credentials}"
  profile                 = "default"
  region                  = "${var.aws_region}"

  version = "~> 2.8"
}