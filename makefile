services:=ssm vsm wallet market miner messager gateway node auth

DC_CHAIN?=docker compose  --env-file chain.env -f compose.chain.yml
DC_CLUSTER?=docker compose  -f compose.cluster.yml
DC_GENESIS?=docker compose --env-file chain.env  -f compose.genesis.yml

DC_ALL?=docker compose  --env-file chain.env -f compose.chain.yml -f compose.cluster.yml -f compose.genesis.yml


chain:
	$(DC_CHAIN) up -d

genesis:
	$(DC_GENESIS) up -d

genesis_d:
	$(DC_GENESIS) stop
	$(DC_GENESIS) rm

cluster:
	$(DC_CLUSTER) up -d wallet
	sleep 5
	$(DC_CLUSTER) up -d

test:
	$(DC_ALL) up -d

clean-all:
	$(DC_ALL) down
	rm -rf .venus
