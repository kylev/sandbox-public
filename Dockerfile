FROM ruby:2.6.5

WORKDIR /opt/app

COPY Gemfile* ./
RUN bundle install --jobs 4 --retry 3

COPY . ./
