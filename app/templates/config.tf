#=========================================================================================== backend


terraform {
  backend "s3" {
    profile = "{{ stateBackend.profile }}"
    bucket = "{{ stateBackend.bucket }}"
    key    = "{{ stateBackend.key }}"
    region = "{{ stateBackend.region }}"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.45.0"
      configuration_aliases = [ aws.london, aws.mumbai ]
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