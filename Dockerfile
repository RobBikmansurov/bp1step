# Dockerfile
# /path/to/your/app/Dockerfile
# docker build -t bp1step:latest .
# docker run --rm -it -v ${PWD}:/app bp1step:latest bundle exec rspec

FROM ruby:2.5.1

RUN apt-get update -qq && apt-get install -y nodejs

# Cache Gems
WORKDIR /tmp
ADD Gemfile .
ADD Gemfile.lock .

RUN bundle install --jobs 4

# Copy your app's code into the image
WORKDIR /app
ADD . /app

# Precompile assets
RUN bundle exec rails assets:precompile
RUN ls -al && ls -al config/ && cp config/database.yml.example config/database.yml
RUN cp config/ldap.yml.example config/ldap.yml
RUN ls -al config/ && cat config/database.yml

RUN bundle exec rake db:migrate
RUN bundle exec rake db:seed

# RUN apt-get install -y libreadline6 libreadline6-dev

# Expose port 3000 to other containers
ENV PORT 3000
EXPOSE $PORT

# Run the rails server
CMD bundle exec rails s -p $PORT
