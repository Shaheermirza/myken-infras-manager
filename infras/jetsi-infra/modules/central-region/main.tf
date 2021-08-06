#=========================================================================================== mumbai region
module "myken_jetsi_backend" {
  source = "./modules/backend"

  module_region = var.module_region
  arrays = var.arrays
}
module "myken_jetsi_jibri" {
  source = "./modules/jibri"

  module_region = var.module_region
  arrays = var.arrays
}
#=========================================================================================== END