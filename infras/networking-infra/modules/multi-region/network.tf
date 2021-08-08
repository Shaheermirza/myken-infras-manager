data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "main-vpc"
  cidr = join("", [local.vpc_cidr_prefix,".0.0/16"])

  azs             = [data.aws_availability_zones.available.names[0],data.aws_availability_zones.available.names[1],data.aws_availability_zones.available.names[2]]
  #private_subnets = [join("", [local.vpc_cidr_prefix,".1.0/24"]), join("", [local.vpc_cidr_prefix,".2.0/24"]), join("", [local.vpc_cidr_prefix,".3.0/24"])]
  public_subnets  = [join("", [local.vpc_cidr_prefix,".101.0/24"]), join("", [local.vpc_cidr_prefix,".102.0/24"]), join("", [local.vpc_cidr_prefix,".103.0/24"])]

  # enable_nat_gateway = true
  # enable_vpn_gateway = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
      Name        = "main-vpc"
      Terraform   = "true"
      Environment = "dev"
  }
}