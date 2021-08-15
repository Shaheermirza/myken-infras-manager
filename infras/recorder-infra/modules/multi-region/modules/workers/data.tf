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

data "aws_subnet" "subnet_a" {
  # for_each = data.aws_subnet_ids.all.ids
  # id       = each.value
  filter {
    name   = "tag:Name"
    values = ["subnet_a"]
  }
  availability_zone = local.availability_zones[0]
}
data "aws_subnet" "subnet_b" {
  # for_each = data.aws_subnet_ids.all.ids
  # id       = each.value
  filter {
    name   = "tag:Name"
    values = ["subnet_b"]
  }
  availability_zone = local.availability_zones[1]
}
data "aws_subnet" "subnet_c" {
  # for_each = data.aws_subnet_ids.all.ids
  # id       = each.value
  filter {
    name   = "tag:Name"
    values = ["subnet_c"]
  }
  availability_zone = local.availability_zones[2]
}

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  availability_zones = sort(data.aws_availability_zones.available.names)
  subnets = [data.aws_subnet.subnet_a.id , data.aws_subnet.subnet_b.id , data.aws_subnet.subnet_c.id ]
  #
  #
}
