//===================================================================================================== data
//===================================================================================================== data
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
//===================================================================================================== params
locals {
    subnets = [for s in data.aws_subnet.default : s.id]

    modulePrefix = ""
    moduleRootName = "jbv"
    moduleVersion = "v1"
    moduleSuffix = "--tf"
    
    moduleName = join("_", [ local.moduleRootName, local.moduleVersion, local.moduleSuffix ] )
    moduleId = join("_", [ local.moduleRootName, local.moduleVersion, local.moduleSuffix ] )
    moduleDescription = join(" ", [ local.moduleRootName, local.moduleVersion, local.moduleSuffix ] )

    managedBy = "myken-infras-manger@terrafom"
    env = "prod"

    ami_per_region = {
        ap-south-1 = "ami-01f26dba3a93268e3"
        eu-west-2 = "ami-0262f3eaca3ff4402"
        ap-southeast-2 = "ami-057d90b2321c05951"
    }

    ami_id = local.ami_per_region[var.module_region]

    instanceType = "c5.xlarge"
}
//===================================================================================================== data
# data "aws_launch_configuration" "jibri_latest_launch_config" {
#    most_recent       = true
#    owners                = ["self"]

#    filter {
#      name     = "Name"
#      values = ["jibri-v*"]
#    }
# }
//===================================================================================================== output
# output "moduleName" {
#     value = provider.region
# }
output "ami_id" {
    value = local.ami_id
}
# output "region" {
#     value = data.aws_region.current.name
# }
//===================================================================================================== END