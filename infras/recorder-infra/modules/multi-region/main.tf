#===========================================================================================
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 2.7.0"
      configuration_aliases = [ aws ]
    }
  }
}
#=========================================================================================== modules
module "myken_recorder_manager" {
  source = "./modules/manager"

  module_region = var.module_region
  arrays = var.arrays
  maps = var.maps
}
#=========================================================================================== END