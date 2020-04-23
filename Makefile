RUN_ARGS := $(wordlist 2, $(words $(MAKECMDGOALS)), $(MAKECMDGOALS))
THIS_FILE := $(lastword $(MAKEFILE_LIST))
.PHONY: help build up start down destroy stop restart logs logs-api ps login-timescale login-api psql setup test rubocop-a rubocop web
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

add-migration:
	docker-compose run web bundle exec rails g migration $(RUN_ARGS)
add-model:
	docker-compose run web bundle exec rails g model $(RUN_ARGS)
db-migrate:
	docker-compose run web bundle exec rake db:migrate
db-rollback:
	docker-compose run web bundle exec rake db:rollback
run-rails:	## run rails
	docker-compose run web bundle exec puma -t 1:1 -b tcp://0.0.0.0:3000
run-sidekiq:	## run sidekiq
	docker-compose run web bundle exec sidekiq -q critical,9 -q default,5 -q low,1

build:	## Buids docker compose file in this directory
	docker-compose -f docker-compose.yml build $(c)
up:	## up containers
	docker-compose -f docker-compose.yml up -d $(c)
start:
	docker-compose -f docker-compose.yml start $(c)
down:	 ## down all containers
	docker-compose down $(c)
destroy:
	docker-compose -f docker-compose.yml down -v $(c)
stop:
	docker-compose -f docker-compose.yml stop $(c)
restart:
	docker-compose -f docker-compose.yml stop $(c)
	docker-compose -f docker-compose.yml up -d $(c)
logs:	## show logs
	docker-compose -f docker-compose.yml logs --tail=100 -f $(c)
logs-api:
	docker-compose -f docker-compose.yml logs --tail=100 -f api
ps:
	docker-compose -f docker-compose.yml ps
login-timescale:
	docker-compose -f docker-compose.yml exec timescale /bin/bash
login-api:
	docker-compose -f docker-compose.yml exec api /bin/bash
psql:	## psql console
	docker-compose -f docker-compose.yml exec db psql --host db --user postgres postgres
setup:	## setup database
	docker-compose run web rails db:setup
test:	## run Rspec tests
	docker-compose run web rspec $(RUN_ARGS) 
rubocop:	## run rubocop
	docker-compose run web rubocop $(RUN_ARGS) 
rubocop-a:	## run rubocop -a
	docker-compose run web rubocop -a $(RUN_ARGS) 
audit:	## run security check utulities
	docker-compose run web bundle audit check --update
	docker-compose run web brakeman --ignore-model-output --rails5 --color
console:	## rails console
	docker-compose run web rails console
web:		## rub web container
	docker-compose run web $(RUN_ARGS)

s:	run-rails
c:	console
w:	web
