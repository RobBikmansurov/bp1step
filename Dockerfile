# Dockerfile
# /path/to/your/app/Dockerfile
# docker-compose up

FROM ruby:2.6.3-stretch

RUN apt-get update && apt-get install -y \
  curl \
  build-essential \
  freetds-dev freetds-bin \
  libpq-dev &&\
  curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  apt-get update && apt-get install -y nodejs \
  && rm -rf /var/lib/apt/lists/*

ENV LANG C.UTF-8

WORKDIR /app

EXPOSE 3000

ADD Gemfile Gemfile.lock /app/
RUN gem update bundler
RUN bundle install --jobs 4
# COPY . /app/
