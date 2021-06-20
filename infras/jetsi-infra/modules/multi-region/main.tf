#===========================================================================================
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 2.7.0"
      configuration_aliases = [ aws.current ]
    }
  }
}
#=========================================================================================== mumbai region
module "myken_jetsi_front" {
  source = "./modules/frontend"
  module_region = var.module_region
  providers = {
    aws = aws.current
  }
}
module "myken_jetsi_jvb" {
  source = "./modules/jvb"
  module_region = var.module_region
  providers = {
    aws = aws.current
  }
}
# output "module_region" {
#     value = var.module_region
# }
#=========================================================================================== END