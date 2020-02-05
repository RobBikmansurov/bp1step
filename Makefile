RUN_ARGS := $(wordlist 2, $(words $(MAKECMDGOALS)), $(MAKECMDGOALS))
THIS_FILE := $(lastword $(MAKEFILE_LIST))
.PHONY: help build up start down destroy stop restart logs logs-api ps login-timescale login-api db-shell
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
build:	## Buids docker compose file in this directory
	docker-compose -f docker-compose.yml build $(c)
up:
	docker-compose -f docker-compose.yml up -d $(c)
start:
	docker-compose -f docker-compose.yml start $(c)
down:	 ## down all containers
	docker-compose -f docker-compose.yml down $(c)
destroy:
	docker-compose -f docker-compose.yml down -v $(c)
stop:
	docker-compose -f docker-compose.yml stop $(c)
restart:
	docker-compose -f docker-compose.yml stop $(c)
	docker-compose -f docker-compose.yml up -d $(c)
logs:
	docker-compose -f docker-compose.yml logs --tail=100 -f $(c)
logs-api:
	docker-compose -f docker-compose.yml logs --tail=100 -f api
ps:
	docker-compose -f docker-compose.yml ps
login-timescale:
	docker-compose -f docker-compose.yml exec timescale /bin/bash
login-api:
	docker-compose -f docker-compose.yml exec api /bin/bash
db-shell:
	docker-compose -f docker-compose.yml exec timescale psql -Upostgres
setup:	## setup database
	docker-compose run web rails db:setup
rspec:	## run Rspec tests
	docker-compose run web rspec $(RUN_ARGS) 
rubocop:	## run rubocop
	docker-compose run web rubocop $(RUN_ARGS) 
