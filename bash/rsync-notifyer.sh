#! /bin/bash

# EXPORT WEBHOOK_URL="webhookurl" in root .bashrc

# Source the bashrc in script
source /root/.bashrc

WEBHOOK_URL=$WEBHOOK_URL

# Run rsync command from cron using 00 4 * * * /bin/bash /root/rsync-notifyer.sh
if rsync -avx  /home/pi/nfsdocker-volumes /glusterfs/data/nfsdocker-volumes ; then

    discord_message="rsync completed successfully on $HOSTNAME "
    curl -X POST -H "Content-Type:application/json" --data '{"content":"'" $discord_message "'"}' $WEBHOOK_URL
else
    discord_message="rsync failed with exit code $?. on $HOSTNAME"
    curl -X POST -H "Content-Type:application/json" --data '{"content":"'" $discord_message "'"}' $WEBHOOK_URL
fi

