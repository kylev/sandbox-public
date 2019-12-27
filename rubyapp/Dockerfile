FROM ruby:2.6.5 AS builder

WORKDIR /app
COPY Gemfile* ./

RUN bundle install --jobs 4 --retry 3 --without development test
COPY . ./

FROM ruby:2.6.5 AS dev

WORKDIR /app
COPY --from=builder /usr/local/bundle /usr/local/bundle/
COPY --from=builder /app ./

RUN bundle install --jobs 4 --retry 3 --with development test

FROM ruby:2.6.5-slim AS slim

WORKDIR /app
COPY --from=builder /usr/local/bundle /usr/local/bundle/
COPY --from=builder /app ./
