#!/bin/bash

echo "Creating virtualenv for python binary: $PYTHON_BIN"

# create our virtualenv
virtualenv -p $PYTHON_BIN /home/app/venv

# activate it
source /home/app/venv/bin/activate

# install app dependencies
pip install --no-cache-dir -r /home/app/app/requirements.txt
