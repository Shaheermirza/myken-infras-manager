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

#=========================================================================================== backend
terraform {
  backend "s3" {
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.45.0"
      configuration_aliases = [ aws.london, aws.mumbai , aws.sydney ]
    }
  }
}
data "terraform_remote_state" "state" {
  backend = "s3"
  config {
    profile = var.stateBackend.profile
    bucket = var.stateBackend.bucket
    key    = var.stateBackend.key
    region = var.stateBackend.region
  }
}
# terraform {
#   backend "local" {
#     path = "files/terraform.tfstate"
#   }
# }
#=========================================================================================== multi region
#mumbai:ap-south-1
module "myken_jetsi_MR_mumbai" {
  source = "./modules/multi-region"
  providers = {
    aws.current = aws.mumbai
  }
  module_region = var.regions.r0
}
#london:eu-west-2
module "myken_jetsi_MR_london" {
  source = "./modules/multi-region"
  providers = {
    aws.current = aws.london
  }
  module_region = var.regions.r1
}
#sydney:ap-southeast-2
module "myken_jetsi_MR_sydney" {
  source = "./modules/multi-region"
  providers = {
    aws.current = aws.sydney
  }
  module_region = var.regions.r2
}
#=========================================================================================== central region
#mumbai:ap-south-1
module "myken_jetsi_CR_mumbai" {
  source = "./modules/central-region"
  providers = {
    aws = aws.mumbai
  }
}
#=========================================================================================== imports
# resource "aws_security_group" "jvb" {
#   # (resource arguments)
# }
#=========================================================================================== debug
#=========================================================================================== END