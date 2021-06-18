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

    ami_id = "ami-01f26dba3a93268e3"
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
output "moduleName" {
    value = local.moduleName
}
//===================================================================================================== END