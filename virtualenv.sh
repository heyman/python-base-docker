#!/bin/bash

# create our virtualenv
virtualenv /home/app/venv

# activate it
source /home/app/venv/bin/activate

# install app dependencies
pip install --no-cache-dir -r /home/app/app/requirements.txt
