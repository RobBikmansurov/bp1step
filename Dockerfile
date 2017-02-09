FROM ruby:2.3

RUN apt-get update -q && apt-get install -yqq \
  build-essential \
  nodejs \
  libpq-dev postgresql-client \
  libxml2-dev libxslt1-dev

# for capybara-webkit
#RUN apt-get install -y libqt4-webkit libqt4-dev xvfb

ENV APP_HOME /bp1step
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/
ADD config/database.yml.example config/database.yml
RUN bundle install --jobs=3 --without staging production

ADD . $APP_HOME
# RUN ls -hal && rubocop & rubocop -fo
# RUN ls -hal && rspec spec/model
