ARG RUBY_VERSION
FROM ruby:$RUBY_VERSION

ARG BUNDLER_VERSION
ARG NODE_MAJOR
ARG YARN_VERSION

# Add PostgreSQL to sources list
# RUN curl -sSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
#   && echo 'deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main' $PG_MAJOR > /etc/apt/sources.list.d/pgdg.list

# Add NodeJS to sources list
RUN curl -sL https://deb.nodesource.com/setup_$NODE_MAJOR.x | bash -

# Add Yarn to the sources list
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo 'deb http://dl.yarnpkg.com/debian/ stable main' > /etc/apt/sources.list.d/yarn.list

# Install dependencies
COPY .dockerdev/Aptfile /tmp/Aptfile
RUN apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get -yq dist-upgrade && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    build-essential \
    nodejs \
    yarn=$YARN_VERSION-1 \
    $(cat /tmp/Aptfile | xargs) && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    truncate -s 0 /var/log/*log


# Allow build-time overrides (eg. to build image with MongoDB Enterprise version)
# Options for MONGO_PACKAGE: mongodb-org OR mongodb-enterprise
# Options for MONGO_REPO: repo.mongodb.org OR repo.mongodb.com
# Example: docker build --build-arg MONGO_PACKAGE=mongodb-enterprise --build-arg MONGO_REPO=repo.mongodb.com .
ARG MONGO_MAJOR
ARG MONGO_VERSION
ARG MONGO_PACKAGE=mongodb-org
ARG MONGO_REPO=repo.mongodb.org

ENV MONGO_PACKAGE=${MONGO_PACKAGE} MONGO_REPO=${MONGO_REPO}

# bashbrew-architectures:amd64 arm64v8
# http://repo.mongodb.org/apt/debian/dists/stretch/mongodb-org/4.2/main/binary-amd64/Packages
RUN echo "deb http://$MONGO_REPO/apt/debian stretch/${MONGO_PACKAGE%/$MONGO_MAJOR main" | tee "/etc/apt/sources.list.d/${MONGO_PACKAGE%}.list"
# RUN echo "deb http://$MONGO_REPO/apt/ubuntu xenial/${MONGO_PACKAGE%-unstable}/$MONGO_MAJOR multiverse" | tee "/etc/apt/sources.list.d/${MONGO_PACKAGE%-unstable}.list"

RUN set -x \
  && apt-get update \
  && apt-get install -y \
    ${MONGO_PACKAGE}=$MONGO_VERSION \
    ${MONGO_PACKAGE}-server=$MONGO_VERSION \
    ${MONGO_PACKAGE}-shell=$MONGO_VERSION \
    ${MONGO_PACKAGE}-mongos=$MONGO_VERSION \
    ${MONGO_PACKAGE}-tools=$MONGO_VERSION \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /var/lib/mongodb \
  && mv /etc/mongod.conf /etc/mongod.conf.orig

# RUN mkdir -p /data/db /data/configdb \
#   && chown -R mongodb:mongodb /data/db /data/configdb
# VOLUME /data/db /data/configdb

COPY docker-entrypoint.sh /usr/local/bin/
RUN ln -s usr/local/bin/docker-entrypoint.sh /entrypoint.sh # backwards compat (3.4)

# Configure bundler and PATH
ENV LANG=C.UTF-8 \
  GEM_HOME=/bundle \
  BUNDLE_JOBS=4 \
  BUNDLE_RETRY=3
ENV BUNDLE_PATH $GEM_HOME
ENV BUNDLE_APP_CONFIG=$BUNDLE_PATH \
  BUNDLE_BIN=$BUNDLE_PATH/bin
ENV PATH /app/bin:$BUNDLE_BIN:$PATH

# Upgrade RubyGems and install required Bundler version 
RUN gem update --system && \
    gem install bundler:$BUNDLER_VERSION

# Create a directory for the app code
RUN mkdir -p /app

WORKDIR /app

RUN yarn install --check-files
