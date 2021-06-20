#=========================================================================================== config
variable "config" {
    type = map(string)
}

#=========================================================================================== provider
provider "aws" {
    access_key = var.config.access_key
    secret_key = var.config.secret_key
    profile = var.config.profile
    region  = var.config.region
}
# output "access" {
#   value = var.config
# }
#=========================================================================================== backend
terraform {
  backend "s3" {
    profile = "myken_infras_manager"
    bucket = "infras-deploy-repo-c0"
    key    = "infras/recorder-infra/terraform/terraform.tfstate"
    region = "ap-south-1"
  }
}
# terraform {
#   backend "local" {
#     path = "relative/path/to/terraform.tfstate"
#   }
# }
#=========================================================================================== modules
module "myken_recorder_manager" {
  source = "./modules/manager"
}

module "myken_recorder_workers" {
  source = "./modules/workers"
}

#=========================================================================================== debug
# data "aws_elasticache_cluster" "main" {

#   filter {
#     name   = "tag:Name"
#     values = ["websocket-cluster-c1"]
#   }
# }
# output "x" {
#   value = data.aws_eip.LB_ip
# }

# resource "aws_route53_record" "www" {
#   zone_id = aws_route53_zone.primary.zone_id
#   name    = "redis.internal.websocket.mykenshomedia.com.au"
#   type    = "CNAME"
#   ttl     = "300"
#   records = [aws_eip.lb.public_ip]
# }
#=========================================================================================== END