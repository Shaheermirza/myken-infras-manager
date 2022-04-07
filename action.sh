#!/bin/bash
# ===================================================================================================== 
action=$1
module=$2
region=$3
echo "init module $module"
echo "usage : bash action.sh [action : init,clean,plan,refresh,deploy,destroy] [module]"
# ===================================================================================================== check params
### Check if a directory does not exist ###
if [ -z $action ] || [ -z $module ]
then
    echo "parameters action and module Required." 
    exit 1 # die with error code 9999
fi
# ===================================================================================================== params
# infra-config-file
templateFile="./app/templates/config.tf"
configFile="./configs/infra.json"

modulePath="./infras/$module"
targetFile="./infras/$module/__config.tf"
moduleAutoConfig="./infras/$module/.auto.tfvars.json"
# ===================================================================================================== copy files
### Check if a directory does not exist ###
if [ ! -d  $modulePath ]
then
    echo "Module $module DOES NOT exists." 
    exit 1 # die with error code 9999
fi
# ===================================================================================================== helpers
function getRandom (){
    echo $(date +"%FT%H%M")
}
# ===================================================================================================== functions
function init () {
    mkdir -p tmp
    tmpConfigFile="./tmp/$(date +"%FT%H%M").json";
    echo "creating tmp file $tmpConfigFile"
    echo '{ "module" : "'$module'" }' > $tmpConfigFile;
   sudo cat <<EOF >./infras/$module/main.tf
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
variable "arrays" {
    type = map(list(string))
}
variable "maps" {
    type = map(map(map(string)))
}
#=========================================================================================== multi region
#mumbai:ap-south-1
module "myken_recorder_MR_mumbai" {
  source = "./modules/multi-region"
  providers = {
    aws = aws.mumbai
  }
  module_region = var.regions.r0
  arrays = var.arrays
  maps = var.maps
}
# #london:eu-west-2
# module "myken_recorder_MR_london" {
#   source = "./modules/multi-region"
#   providers = {
#     aws = aws.london
#   }
#   module_region = var.regions.r1
#   arrays = var.arrays
#   maps = var.maps
# }
# #sydney:ap-southeast-2
# module "myken_recorder_MR_sydney" {
#   source = "./modules/multi-region"
#   providers = {
#     aws = aws.sydney
#   }
#   module_region = var.regions.r2
#   arrays = var.arrays
#   maps = var.maps
# }
#=========================================================================================== END
EOF
   # mv ./infras/$module/mumbai.tf ./infras/$module/main.tf
    python app/scripts/generate-file-from-template.py $configFile $tmpConfigFile $tmpConfigFile
    cp $tmpConfigFile $moduleAutoConfig
    python app/scripts/generate-file-from-template.py $templateFile $tmpConfigFile $targetFile

    cd ./infras/$module
    terraform init
    cd ../..
    rm -rf $tmpConfigFile;
}
function clean () {
    cd ./infras/$module
    rm -rf .terraform*
    #terraform init -reconfigure
    echo "module cleaned!"
    cd ../..
}
function plan () {
    cd ./infras/$module
    terraform plan
    cd ../..
}
function refresh () {
    cd ./infras/$module
    terraform apply -refresh-only -auto-approve
    cd ../..
}
function deploy () {
    cd ./infras/$module
    terraform apply -auto-approve
    cd ../..
}
function destroy () {
    cd ./infras/$module
    terraform destroy -auto-approve
    cd ../..
}

# ===================================================================================================== start
function exec () {
    case $action in

        init)
            init
            ;;
        clean)
            clean
            ;;
        plan)
            plan
            ;;
        refresh)
            refresh
            ;;
        deploy)
            deploy
            ;;
        destroy)
            destroy
            ;;

        *)
            echo -n "unknown action $action"
            ;;
    esac
}
# =====================================================================================================
# =====================================================================================================
# =====================================================================================================
# =====================================================================================================
#echo exec
exec
# =====================================================================================================