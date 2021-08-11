#!/bin/bash 
#========================================================================================================== params
RANDOM_NUM=$(awk -v min=1 -v max=9999999999 'BEGIN{srand(); print int(min+rand()*(max-min+1))}')
echo $RANDOM_NUM
TIME_STAMP=$( date "+%s%N")
echo $TIME_STAMP
NICK_NAME="$RANDOM_NUM$TIME_STAMP"
echo $NICK_NAME
#========================================================================================================== set user.infos file
echo "[infos]" > /home/ubuntu/.aws/user.infos
echo "region=${region}" > /home/ubuntu/.aws/user.infos
echo "aws_user_access_key=${aws_user_access_key}" >> /home/ubuntu/.aws/user.infos
echo "aws_user_access_secret=${aws_user_access_secret}" >> /home/ubuntu/.aws/user.infos
#========================================================================================================== configure ubuntu
aws configure set default.region ${region}
aws configure set aws_access_key_id ${aws_user_access_key}
aws configure set aws_secret_access_key ${aws_user_access_secret}
#========================================================================================================== configure root
sudo -i -u ubuntu bash << EOF
aws configure set default.region ${region}
aws configure set aws_access_key_id ${aws_user_access_key}
aws configure set aws_secret_access_key ${aws_user_access_secret}
# set user credentials
# ...
#
EOF
#==========================================================================================================
#sleep 1m
#service jibri start
#==========================================================================================================
exit 0
#========================================================================================================== exec