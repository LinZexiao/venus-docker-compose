services:=ssm vsm wallet market miner messager gateway node auth

DC?=docker compose

up:
	$(DC) up -d
u: up

down:
	$(DC) down
	# docker-compose stop ${services}
	# docker-compose rm ${services}
d: down

stop:
	$(DC) stop ${services}
s: stop

clean: down
	rm -rf .venus/root/.venus*

genesis:
	$(DC) up -d genesis

clean-all:
	$(DC) stop
	$(DC) rm -f
	rm -rf .venus

# log for all services
l_chain:
	$(DC) logs -f ${services}

# log for all services
l_cluster:
	$(DC) logs -f vsm worker

extract:
	nohup $(DC) logs -f vsm > vsm.log &
	nohup $(DC) logs -f worker > worker.log &
