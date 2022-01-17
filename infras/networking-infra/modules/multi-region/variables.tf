variable "module_region" {
  description = "Module Region Name"
  type        = string
  default = "null"
}
variable "arrays" {
  description = "Module arrays var"
  type        = map(list(string))
  default     = {}
}
locals {

    modulePrefix = ""
    moduleRootName = "jbv"
    moduleVersion = "v1"
    moduleSuffix = "--tf"
    
    moduleName = join("_", [ local.moduleRootName, local.moduleVersion, local.moduleSuffix ] )
    moduleId = join("_", [ local.moduleRootName, local.moduleVersion, local.moduleSuffix ] )
    moduleDescription = join(" ", [ local.moduleRootName, local.moduleVersion, local.moduleSuffix ] )

    managedBy = "myken-infras-manger@terrafom"
    env = "prod"

    vpc_cidr_per_region = {
        ap-south-1 = "10.0"
        eu-west-2 = "10.1"
        ap-southeast-2 = "10.2"
        # ap-south-1 = "10.0.0.0/16"
        # eu-west-2 = "10.1.0.0/16"
        # ap-southeast-2 = "10.2.0.0/16"
    }

    vpc_cidr_prefix = local.vpc_cidr_per_region[var.module_region]

}