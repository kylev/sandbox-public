.PHONY: build test test_ruby test_opsbot

DCO = docker-compose

build:
	$(DCO) build

test: test_ruby test_opsbot

test_ruby:
	$(DCO) run --rm rubyapp bundle exec rspec

test_opsbot:
	$(DCO) run --rm opsbot nosetests
