services:=ssm sector-manager wallet market miner messager gateway venus auth
down:
	docker-compose stop ${services}
	docker-compose rm -f ${services}
d: down

up:
	docker-compose --env-file env up -d 
u: up

stop:
	docker-compose stop ${services}
s: stop

clean-all: 
	docker-compose down
	rm -rf .venus
