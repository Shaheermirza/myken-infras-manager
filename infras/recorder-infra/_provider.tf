# _provider.tf
#=========================================================================================== provider
provider "aws" {
    access_key = var.config.access_key
    secret_key = var.config.secret_key
    profile = var.config.profile
    region  = var.config.region
}
# output "access" {
#   value = var.config
# }
#=========================================================================================== provider.regions
# provider "aws" {
#     region = var.regions.r0
#     alias  = "mumbai"
#     access_key = var.config.access_key
#     secret_key = var.config.secret_key
#     profile = var.config.profile
# }
provider "aws" {
    region = var.regions.r1
    alias  = "london"
    access_key = var.config.access_key
    secret_key = var.config.secret_key
    profile = var.config.profile

}
provider "aws" {
    region = var.regions.r2
    alias  = "sydney"
    access_key = var.config.access_key
    secret_key = var.config.secret_key
    profile = var.config.profile
}
#=========================================================================================== END