# Dockerfile
# /path/to/your/app/Dockerfile
# docker-compose up

FROM ruby:2.6.3-slim-stretch

RUN apt-get update && apt-get install -y \
  curl \
  build-essential \
  freetds-dev freetds-bin \
  locales \
  libpq-dev &&\
  curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  apt-get update && apt-get install -y nodejs \
  && rm -rf /var/lib/apt/lists/*
RUN locale-gen ru_RU.UTF-8
ENV LANGUAGE ru_RU.UTF-8
ENV LANG ru_RU.UTF-8
ENV LC_ALL ru_RU.UTF-8

RUN mkdir /app
WORKDIR /app

EXPOSE 3000

COPY Gemfile .
COPY Gemfile.lock .
RUN gem update bundler
RUN bundle install --jobs 4
