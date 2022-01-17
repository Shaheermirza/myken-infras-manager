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
module "myken_websocket_redis" {
  source = "./modules/redis"
  
  module_region = var.module_region
  arrays = var.arrays
}

#=========================================================================================== END