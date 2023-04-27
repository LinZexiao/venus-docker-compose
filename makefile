services:=ssm vsm wallet market miner messager gateway node auth

DC?=docker compose

down:
	$(DC) down
	# docker-compose stop ${services}
	# docker-compose rm ${services}
d: down

up:
	$(DC) up -d
u: up

stop:
	$(DC) stop ${services}
s: stop

clean: down
	rm -rf .venus/root/.venus*

genesis:
	$(DC) start genesis

clean-all:
	$(DC) stop
	$(DC) rm -f
	rm -rf .venus
