#!/bin/bash 
#========================================================================================================== params
RANDOM_NUM=$(awk -v min=1 -v max=9999999999 'BEGIN{srand(); print int(min+rand()*(max-min+1))}')
echo $RANDOM_NUM
TIME_STAMP=$( date "+%s%N")
echo $TIME_STAMP
NICK_NAME="$RANDOM_NUM$TIME_STAMP"
echo $NICK_NAME
#========================================================================================================== set /home/ubuntu/.aws/credentials
sudo -i -u ubuntu bash << EOF
pm2 stop all

cd /data/apps/task-manager

echo ${config_file_content}  | base64 --decode > /data/apps/task-manager/configs/main.json

git reset --hard HEAD
git clean -f -d
git checkout prod
git fetch origin prod
git reset --hard origin/prod
git pull


echo "[default] ; region=${region}" > /home/ubuntu/.aws/credentials
echo "aws_access_key_id = ${aws_user_access_key}" >> /home/ubuntu/.aws/credentials
echo "aws_secret_access_key = ${aws_user_access_secret}" >> /home/ubuntu/.aws/credentials

sleep 1m
pm2 restart all

EOF
#==========================================================================================================
#==========================================================================================================
exit 0
#========================================================================================================== exec