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
    profile = var.stateBackend.profile
    bucket = var.stateBackend.bucket
    key    = var.stateBackend.key
    region = var.stateBackend.region
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.45.0"
      configuration_aliases = [ aws.london, aws.mumbai , aws.sydney ]
    }
  }
}
# data "terraform_remote_state" "state" {
#   backend = "s3"
#   config {
#     profile = var.stateBackend.profile
#     bucket = var.stateBackend.bucket
#     key    = var.stateBackend.key
#     region = var.stateBackend.region
#   }
# }
# terraform {
#   backend "local" {
#     path = "files/terraform.tfstate"
#   }
# }
#===========================================================================================