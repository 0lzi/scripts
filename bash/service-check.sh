#!/bin/bash

#crontab - check every 5 min.
# */5 * * * * /root/service-check.sh

SERVICE_NAME="SERVICE NAME" # eg nginx

is_service_running() {
    if systemctl is-active --quiet $SERVICE_NAME; then
        return 0
    else
        return 1
    fi
}

start_or_restart_service() {
    if is_service_running; then
        return 0
    else
        systemctl start $SERVICE_NAME
    fi
}

# Main script
start_or_restart_service

exit 0