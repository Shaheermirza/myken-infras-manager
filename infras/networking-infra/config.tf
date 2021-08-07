#=========================================================================================== backend


terraform {
  backend "s3" {
    profile = "myken_infras_manager"
    bucket = "infras-deploy-repo-c1"
    key    = "infras/jetsi-infra/terraform/terraform.tfstate"
    region = "ap-south-1"
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