# Dockerfile
# /path/to/your/app/Dockerfile
# docker-compose up

ARG POSTGRES_VERSION
ARG RUBYGEMS_VERSION
ARG BUNDLER_VERSION

FROM ruby:2.7.2-slim

RUN apt-get update && apt-get install -y \
  curl \
  build-essential \
  freetds-dev freetds-bin \
  libpq-dev shared-mime-info apt-utils && \
  curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  apt-get update && apt-get install -y nodejs \
  && apt-get clean \
  && rm -rf /var/cache/apt/archives/* \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log

WORKDIR /app

ENV LANG=C.UTF-8 \
  BUNDLE_JOBS=4 \
  BUNDLE_RETRY=3
RUN gem update --system ${RUBYGEMS_VERSION} \
  && gem install --default bundler -v ${BUNDLER_VERSION}

EXPOSE 3000

CMD ["/usr/bin/bash"]