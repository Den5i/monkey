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

variable "chef_username" {
  default = "denys"
}

variable "chef_user" {
  default = "Denys"
}

variable "chef_user_email" {
  default = "denys@example.com"
}

variable "chef_organization_id" {
  default = "Example Inc"
}

variable "chef_organization_name" {
  default = "Example"
}

variable "domain_name" {
  default = "example.com"
}

variable "chef_pwd" {
  default = ""
}