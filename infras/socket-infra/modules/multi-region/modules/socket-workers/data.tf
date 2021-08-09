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
# data "aws_subnet" "default" {
#   for_each = data.aws_subnet_ids.all.ids
#   id       = each.value
# }
# locals {
#   subnets = [for s in data.aws_subnet.default : s.id]
# }
# output "aws_vpc" {
#   value = local.subnets
# }