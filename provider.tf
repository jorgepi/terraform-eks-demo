terraform {
  required_version = "~> 0.10"

  backend "s3" {
    bucket = "terraform-eks-demo"
    key    = "eks-demo"
    region = "eu-west-1"
  }
}

provider "aws" {
  region = "${var.aws_region}"
}
