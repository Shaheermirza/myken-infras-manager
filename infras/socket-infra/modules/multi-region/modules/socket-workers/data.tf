data "aws_vpc" "default" {
  #default = true
  filter {
    name   = "tag:Name"
    values = ["main-vpc"]
  }
}

data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.default.id
}
data "aws_subnet" "default" {
  for_each = data.aws_subnet_ids.all.ids
  id       = each.value

  depends_on = [data.aws_subnet_ids.all]
}
data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  #subnets = [for s in data.aws_subnet.default : s.id]
  availability_zones = data.aws_availability_zones.available.names
  #
  availability_zone_subnets = {
    for s in data.aws_subnet.default : s.availability_zone => s.id...
  }
  # availability_zone_subnets = 
  # {
  #   "az1-a" = ["subnetid1", "subnetid4"]
  #   "az1-b" = ["subnetid2"]
  #   "az1-c" = ["subnetid3"]
  # }
  subnets = [for subnet_ids in local.availability_zone_subnets : sort(subnet_ids)[0]]
  #
  #
}
output "aws_vpc" {
  value = local.subnets
}
