FROM python:3.11-bookworm

# install apt packages
RUN apt-get update && apt-get install -y \
    sudo \
    locales \
    software-properties-common \
    python3-pip \
    libmemcached-dev \
    libgdal-dev \
    ruby \
    ruby-dev \
    rsync

# Python 3.10
#RUN add-apt-repository -y ppa:deadsnakes/ppa && apt-get update && apt-get install -y python3.10 python3.10-dev python3.10-lib2to3 python3.10-distutils

# Node and NPM
#RUN apt-get install -y nodejs npm
RUN mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_22.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list && \
    apt-get update && apt-get install -y nodejs

ENV NODE_PATH /usr/local/lib/node_modules

# Add build scripts
RUN mkdir /build
ADD . /build
RUN chmod +x /build/*.sh

# Create app user
RUN /build/create-user.sh

# Install virtualenv
RUN pip3 install virtualenv

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Configure locale
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8
ENV LC_ALL en_US.UTF-8

#RUN locale-gen en_US en_US.UTF-8
#ENV LC_ALL en_US.UTF-8

# Copy just requirements.txt (in order to avoid reinstalling python dependencies 
# when no changes has been made to requirements.txt)
ONBUILD RUN mkdir -p /home/app/app
ONBUILD COPY ./requirements.txt /home/app/app/requirements.txt

# Create virtualenv

ONBUILD ARG PYTHON_BIN=python3.11
ONBUILD RUN sudo -u app env PYTHON_BIN=${PYTHON_BIN} /build/virtualenv.sh

# If there is a package.json file, install node dependencies in /home/app
ONBUILD COPY package.jso[n] package-lock.jso[n] /home/app/
# TODO: if npm install fails, it will fail silently, this should be fixed
ONBUILD RUN test -f /home/app/package.json && cd /home/app && npm install || true

# Hook for installing stuff before all the app code is copied (which invalidates cache)
ONBUILD COPY ./docker-onbuild.s[h] /home/app/app/docker-onbuild.sh
ONBUILD RUN test -f /home/app/app/docker-onbuild.sh && chmod +x /home/app/app/docker-onbuild.sh && /home/app/app/docker-onbuild.sh || true

# Add all app files
ONBUILD COPY --chown=app:app . /home/app/app
# The --chown flag won't actually change the owner of the /home/app/app dir, just the contents
ONBUILD RUN chown app:app /home/app/app

# Make virtualenv python the default python
ONBUILD ENV PATH /home/app/venv/bin:$PATH

# Make python run in unbuffered mode
ONBUILD ENV PYTHONUNBUFFERED 1

VOLUME ["/app"]
WORKDIR /home/app/app
ENTRYPOINT ["/build/entrypoint.sh"]
