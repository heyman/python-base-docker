FROM buildpack-deps:18.04
MAINTAINER Jonatan Heyman <http://heyman.info>

# install apt packages
RUN apt-get update && apt-get install -y \
    sudo \
    locales \
    python python2.7 python-dev python-pip \
    python3.6 python3.6-dev \
    libmemcached-dev \
    libgdal-dev \
    ruby \
    ruby-dev

# Add build scripts
RUN mkdir /build
ADD . /build
RUN chmod +x /build/*.sh

# Create app user
RUN /build/create-user.sh

# Install virtualenv
RUN pip install virtualenv

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Configure locale
RUN locale-gen en_US en_US.UTF-8
ENV LC_ALL en_US.utf-8


# Copy just requirements.txt (in order to avoid reinstalling python dependencies 
# when no changes has been made to requirements.txt)
ONBUILD RUN mkdir -p /home/app/app
ONBUILD COPY ./requirements.txt /home/app/app/requirements.txt

# Create virtualenv

ONBUILD ARG PYTHON_BIN=python
#ONBUILD RUN sudo -u app env PYTHON_BIN=${PYTHON_BIN} /build/virtualenv.sh
ONBUILD RUN env PYTHON_BIN=${PYTHON_BIN} /build/virtualenv.sh
ONBUILD RUN chown -R app:app /home/app/venv

# Add all app files
ONBUILD COPY . /home/app/app
ONBUILD RUN chown -R app:app /home/app

# Make virtualenv python the default python
ONBUILD ENV PATH /home/app/venv/bin:$PATH

VOLUME ["/app"]
WORKDIR /home/app/app
ENTRYPOINT ["/build/entrypoint.sh"]
