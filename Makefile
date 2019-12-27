.PHONY: build bundle test test_ruby test_opsbot

DCO = docker-compose

build:
	$(DCO) build

bundle:
	$(DCO) run --rm rubyapp bundle install --binstubs

test: test_ruby test_opsbot

test_ruby:
	$(DCO) run --rm rubyapp ./bin/rspec

test_opsbot:
	$(DCO) run --rm opsbot nosetests
