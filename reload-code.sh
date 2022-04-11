#!/bin/bash

# copy app code if volume is mounted
if [ "$(ls /app)" ]
  then
    echo "Copying new code from /app to /home/app/app"
    rm -rf /home/app/app && rsync -a --exclude='.git' /app/ /home/app/app/ && cd /home/app/app
  else
    echo "No new app code found in /app. Using code from docker image"
fi
