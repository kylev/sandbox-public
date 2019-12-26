provider "aws" {
  region = "us-west-2"
}

terraform {
  backend "s3" {
    bucket = "kylev-utility"
    key    = "tf/sandbox.tfstate"
    region = "us-west-2"
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "sandbox"

  cidr = "10.0.0.0/16"

  azs             = ["us-west-2a", "us-west-2b", "us-west-2c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]

  enable_ipv6 = true

  tags = {
    Owner       = "@kylev"
    Environment = "dev"
  }

  vpc_tags = {
    Name = "sandbox"
  }
}
