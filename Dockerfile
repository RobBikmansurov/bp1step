ARG BASE_IMAGE

FROM ${BASE_IMAGE}

ARG POSTGRES_VERSION
ARG RUBYGEMS_VERSION
ARG BUNDLER_VERSION

RUN apt-get -qq update && \
  DEBIAN_FRONTEND=noninteractive apt-get -qy install \
  curl less vim \
  build-essential \
  freetds-dev freetds-bin \
  libpq-dev lsb-release shared-mime-info apt-utils && \
  echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/postgres.list && \
  curl -sS https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
  curl -sL https://deb.nodesource.com/setup_16.x | bash - && \
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  apt-get -qq update && \
  DEBIAN_FRONTEND=noninteractive apt-get -qy install nodejs && \
  apt-get -y install postgresql-client-${POSTGRES_VERSION} \
  && apt-get clean \
  && rm -rf /var/cache/apt/archives/* \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log

ENV LANG=C.UTF-8 \
  BUNDLE_JOBS=4 \
  BUNDLE_RETRY=3
RUN gem update --system ${RUBYGEMS_VERSION} \
  && gem install --default bundler -v ${BUNDLER_VERSION}

EXPOSE 3000

CMD ["/usr/bin/bash"]
