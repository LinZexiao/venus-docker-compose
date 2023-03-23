services:=ssm vsm wallet market miner messager gateway node auth
down:
	docker-compose down
	# docker-compose stop ${services}
	# docker-compose rm ${services}
d: down

up:
	docker-compose up -d
u: up

stop:
	docker-compose stop ${services}
s: stop

clean: down
	rm -rf .venus/root/.venus*

genesis:
	docker-compose -f ./genesis.yaml up -d

clean-all:
	docker-compose stop
	docker-compose rm -f
	rm -rf .venus

start:
	docker-compose -f ./genesis.yaml up -d
	@sleep 15
	echo finish genesis
	docker-compose up -d
