FROM ubuntu:14.04
MAINTAINER Jonatan Heyman <http://heyman.info>

# install apt packages
RUN apt-get update && apt-get install -y \
    python python2.7 python-dev python-setuptools \
    libpq-dev \
    libmemcached-dev \
    ruby \
    ruby-dev \
    make \
    libffi-dev \
    libssl-dev \
    libxml2-dev \
    libxslt1-dev \
    libjpeg-dev \
    git

# Add build scripts
RUN mkdir /build
ADD . /build
RUN chmod +x /build/*.sh

# Create app user
RUN /build/create-user.sh

# Install virtualenv
RUN easy_install virtualenv

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Configure locale
ENV LC_ALL C.UTF-8

# Add app files
ONBUILD ADD . /home/app/app
ONBUILD RUN chown -R app:app /home/app

# Create virtualenv
ONBUILD RUN sudo -u app /build/virtualenv.sh

# Make virtualenv python the default python
ONBUILD ENV PATH /home/app/venv/bin:$PATH

VOLUME ["/app"]
WORKDIR /home/app/app
ENTRYPOINT ["/build/entrypoint.sh"]
