FROM ruby:2.6.5

WORKDIR /opt/app
COPY Gemfile* ./

ARG WITHOUT_GROUPS="development test"
RUN bundle install --without ${WITHOUT_GROUPS} --jobs 4 --retry 3

COPY . ./
