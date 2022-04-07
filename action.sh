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
    if [ $module == "recorder-infra" ]
    then
    sudo sed -i 's/t2.xlarge/t2.2xlarge/g' ./app/infras/$module/worker-json/main.json
    sudo cp ./app/infras/$module/worker-json/main.json ./infras/$module/modules/multi-region/modules/manager/data/main.json

    case "$region" in
   "all") sudo cp ./app/infras/$module/all.tf ./infras/$module/main.tf
   ;;
   "mumbai") sudo cp ./app/infras/$module/mumbai.tf ./infras/$module/main.tf
   ;;
   "sydney") sudo cp ./app/infras/$module/sydney.tf ./infras/$module/main.tf 
   ;;
   "london") sudo cp ./app/infras/$module/london.tf ./infras/$module/main.tf 
   ;;
    esac
    fi
    #sudo mv ./app/infras/$module/mumbai.tf ./infras/$module/main.tf
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