#!/bin/bash 
RANDOM_NUM=$(awk -v min=1 -v max=9999999999 'BEGIN{srand(); print int(min+rand()*(max-min+1))}')
echo $RANDOM_NUM
TIME_STAMP=$( date "+%s%N")
echo $TIME_STAMP
NICK_NAME="$RANDOM_NUM$TIME_STAMP"
echo $NICK_NAME
JSON_STRING=$( jq -n \
                  --arg nn "$NICK_NAME" \
                  '{

    "recording_directory":"/tmp/recordings",
    "finalize_recording_script_path": "/home/jibri/finalize_recording.sh",
    "xmpp_environments": [
        {
            "name": "prod environment",
            "xmpp_server_hosts": [
                "octomeet.mykenshomedia.com.au"
            ],
            "xmpp_domain": "octomeet.mykenshomedia.com.au",
            "control_login": {
                "domain": "auth.octomeet.mykenshomedia.com.au",
                "username": "jibri",
                "password": "nghjkert"
            },
            "control_muc": {
                "domain": "internal.auth.octomeet.mykenshomedia.com.au",
                "room_name": "JibriBrewery",
                "nickname": $nn
            },
            "call_login": {
                "domain": "recorder.octomeet.mykenshomedia.com.au",
                "username": "recorder",
                "password": "kjrteuty"
            },
            "room_jid_domain_string_to_strip_from_start": "conference.",
            "usage_timeout": "0"
        }
    ]
}' )
echo  $JSON_STRING > /etc/jitsi/jibri/config.json
echo  $JSON_STRING
sleep 1m
service jibri start
exit 0