.PHONY: build test

DCO = docker-compose

build:
	$(DCO) build

test:
	$(DCO) run --rm sandbox bundle exec rspec
