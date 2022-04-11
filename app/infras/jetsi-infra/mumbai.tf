#=========================================================================================== config
variable "config" {
    type = map(string)
}
variable "regions" {
    type = map(string)
}
variable "stateBackend" {
    type = map(string)
}
variable "arrays" {
    type = map(list(string))
}
#=========================================================================================== multi region
#mumbai:ap-south-1
module "myken_jetsi_MR_mumbai" {
  source = "./modules/multi-region"
  providers = {
    aws.current = aws.mumbai
  }
  module_region = var.regions.r0
  arrays = var.arrays
}
# #london:eu-west-2
# module "myken_jetsi_MR_london" {
#   source = "./modules/multi-region"
#   providers = {
#     aws.current = aws.london
#   }
#   module_region = var.regions.r1
#   arrays = var.arrays
# }
# #sydney:ap-southeast-2
# module "myken_jetsi_MR_sydney" {
#   source = "./modules/multi-region"
#   providers = {
#     aws.current = aws.sydney
#   }
#   module_region = var.regions.r2
#   arrays = var.arrays
# }
#=========================================================================================== central region
#mumbai:ap-south-1
module "myken_jetsi_CR_mumbai" {
  source = "./modules/central-region"
  providers = {
    aws = aws.mumbai
  }
  module_region = var.regions.r0
  arrays = var.arrays
}
#=========================================================================================== imports

#=========================================================================================== debug
#=========================================================================================== END