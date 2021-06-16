data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.default.id
}
data "aws_subnet" "default" {
  for_each = data.aws_subnet_ids.all.ids
  id       = each.value
}
locals {
  subnets = [for s in data.aws_subnet.default : s.id]
}
output "aws_vpc" {
  value = local.subnets
}
//===================================================================================================== data
# data "aws_launch_configuration" "jibri_latest_launch_config" {
#   most_recent      = true
#   owners           = ["self"]

#   filter {
#     name   = "Name"
#     values = ["jibri-v*"]
#   }
# }
//===================================================================================================== 