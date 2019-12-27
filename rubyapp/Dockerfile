FROM ruby:2.6.5 AS builder

WORKDIR /app
COPY Gemfile* ./

ARG WITHOUT_GROUPS="development test"
RUN bundle install --path vendor/bundle --without ${WITHOUT_GROUPS} --jobs 4 --retry 3

COPY . ./

FROM ruby:2.6.5-slim

WORKDIR /app
COPY --from=builder /app ./
