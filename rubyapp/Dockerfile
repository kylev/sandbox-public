FROM ruby:2.6.5 AS builder

WORKDIR /opt/app
COPY Gemfile* ./

ARG bundler_args="--without development test"
RUN \
        bundle install --jobs 4 --retry 3 $bundler_args && \
        rm -rf /usr/local/bundle/cache

COPY . ./

FROM ruby:2.6.5-slim

WORKDIR /opt/app
COPY --from=builder /usr/local/bundle /usr/local/bundle/
COPY --from=builder /opt/app ./
