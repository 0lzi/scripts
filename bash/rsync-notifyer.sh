#! /bin/bash

# export WEBHOOK_URL="webhookurl" in root .bashrc

# Source the bashrc in script
source /root/.bashrc

WEBHOOK_URL=$WEBHOOK_URL

# Run rsync command from cron using 00 4 * * * /bin/bash /root/rsync-notifyer.sh
if rsync -avx  /home/pi/nfsdocker-volumes /glusterfs/data/nfsdocker-volumes ; then
    TITLE="✅ rsync completed on '$HOSTNAME' ✅"
    COLOUR=65280
    DATETIME=$(/usr/bin/date)
    MESSAGE="'$DATETIME'"
    discord_message=$( jq -n \
        --arg title "$TITLE" \
        --arg colour "$COLOUR" \
        --arg message "$MESSAGE" \
        --arg hostname "$HOSTNAME" \
        '{"embeds":[{"title": $title , "color": ($colour | tonumber), "fields": [{"name": "host","value": $hostname },{"name": "Completed at","value": $message,}]}]}')

    curl -X POST -H "Content-Type:application/json" --data "$discord_message" "$WEBHOOK_URL"
else
    TITLE="❌ rsync failed on '$HOSTNAME' ❌"
    COLOUR=16711680
    DATETIME=$(/usr/bin/date)
    MESSAGE="'$DATETIME'"
    discord_message=$( jq -n \
        --arg title "$TITLE" \
        --arg colour "$COLOUR" \
        --arg message "$MESSAGE" \
        --arg hostname "$HOSTNAME" \
        '{"embeds":[{"title": $title , "color": ($colour | tonumber), "fields": [{"name": "host","value": $hostname },{"name": "Failed at","value": $message,}]}]}')

    curl -X POST -H "Content-Type:application/json" --data "$discord_message" "$WEBHOOK_URL"
fi
