#!/bin/bash
echo "init project x"

# =====================================================================================================n params
# infra-config-file
configFile="./configs/myken-c0.json"
# ===================================================================================================== functions
# | jsawk -a 'return this.name'
# echo '{"hostname":"test","domainname":"example.com"}' | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["hostname"]'
# curl -s 'http://twitter.com/users/username.json' | python -mjson.tool | grep my_key
# function getJsonVal () { 
#    python -c "import json,sys;sys.stdout.write(json.dumps(json.load(sys.stdin)$1))"; 
# }
function getJsonAttribute()
{
    echo $1 | jq -r ".$2"
    #return $(jq -r ".$2" <<< "$1")
}
# ===================================================================================================== get config
stateBackend=$(cat $configFile | jq -rc '.stateBackend')
#echo "stateBackend=$stateBackend"
# ===================================================================================================== get vars
profile=$(getJsonAttribute $stateBackend profile)
bucket=$(getJsonAttribute $stateBackend bucket)
key=$(getJsonAttribute $stateBackend key)
region=$(getJsonAttribute $stateBackend region)

#echo "bucket=$bucket"
#exit 0;
# ===================================================================================================== start
cd ./infras/jetsi-infra

terraform init -backend-config "bucket=$bucket"  -backend-config "bucket=$bucket" -backend-config "key=$key" -backend-config "region=$region"

cd ../..
# =====================================================================================================
# =====================================================================================================
# =====================================================================================================
# =====================================================================================================
# =====================================================================================================