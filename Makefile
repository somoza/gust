ENV_FILE ?= .env
ifneq (,$(wildcard ${ENV_FILE}))
	include ${ENV_FILE}
	export
endif

dev:
	mix phx.server

test:
	mix test

test.until_fail:
	mix test --repeat-until-failure 10

test-cover:
	MIX_ENV=test mix coveralls.html --umbrella

lint:
	mix lint

console:
	iex -S mix

install:
	cp .env.make .env
	export $$(cat .env | xargs)
	cd apps/gust_web/assets && npm install
	mix deps.get
	mix assets.deploy
	mix ecto.create
	mix ecto.migrate
	mkdir -p dags
	touch dags/.gitkeep
