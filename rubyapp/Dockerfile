FROM ruby:2.6.5 AS builder

WORKDIR /app
COPY Gemfile* ./

ARG BUNDLE_ARGS="--without development test"
RUN bundle install --jobs 4 --retry 3 ${BUNDLE_ARGS}

COPY . ./

FROM ruby:2.6.5-slim

WORKDIR /app
COPY --from=builder /usr/local/bundle /usr/local/bundle/
COPY --from=builder /app ./
