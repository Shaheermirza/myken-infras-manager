#=========================================================================================== mumbai region
module "myken_jetsi_backend" {
  source = "./modules/backend"
}
module "myken_jetsi_jibri" {
  source = "./modules/jibri"
}
#=========================================================================================== END