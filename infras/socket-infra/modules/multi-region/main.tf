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
module "myken_websocket_LB" {
  source = "./modules/socket-LB"

  module_region = var.module_region
  arrays = var.arrays
  maps = var.maps
}

module "myken_websocket_workers" {
  source = "./modules/socket-workers"

  module_region = var.module_region
  arrays = var.arrays
  maps = var.maps

  depends_on = [module.myken_websocket_LB]
}
#=========================================================================================== END