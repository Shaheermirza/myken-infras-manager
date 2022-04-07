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
variable "maps" {
    type = map(map(map(string)))
}
#=========================================================================================== multi region
#mumbai:ap-south-1
module "myken_recorder_MR_mumbai" {
  source = "./modules/multi-region"
  providers = {
    aws = aws.mumbai
  }
  module_region = var.regions.r0
  arrays = var.arrays
  maps = var.maps
}
# #london:eu-west-2
# module "myken_recorder_MR_london" {
#   source = "./modules/multi-region"
#   providers = {
#     aws = aws.london
#   }
#   module_region = var.regions.r1
#   arrays = var.arrays
#   maps = var.maps
# }
# #sydney:ap-southeast-2
# module "myken_recorder_MR_sydney" {
#   source = "./modules/multi-region"
#   providers = {
#     aws = aws.sydney
#   }
#   module_region = var.regions.r2
#   arrays = var.arrays
#   maps = var.maps
# }
#=========================================================================================== END