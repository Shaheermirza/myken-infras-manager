#!/bin/bash
# ===================================================================================================== 
action=$1
module=$2
echo "init module $module"
echo "usage : bash action.sh [action : init,plan,deploy,destroy] [module]"
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
targetFile="./infras/$module/config.tf"
moduleAutoConfig="./infras/$module/.auto.tfvars.json"
# ===================================================================================================== copy files
### Check if a directory does not exist ###
if [ ! -d  $modulePath ]
then
    echo "Module $module DOES NOT exists." 
    exit 1 # die with error code 9999
fi
# ===================================================================================================== functions
function init () {
    cp $configFile $moduleAutoConfig
    python app/scripts/generate-file-from-template.py $templateFile $configFile $targetFile
    cd ./infras/$module
    terraform init
    cd ../..
}
function plan () {
    cd ./infras/$module
    terraform plan
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
        plan)
            plan
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