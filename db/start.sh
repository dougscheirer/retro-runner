#!/bin/bash
DOCKER_NAME=pg_retrorunner
DOCKER_DB=$(docker ps -qf name=$DOCKER_NAME)
if [ "$DOCKER_DB" != "" ]; then
	echo "already running: $DOCKER_DB" && exit 0
fi

DOCKER_DB=$(docker ps -aqf name=$DOCKER_NAME)

if [ "$DOCKER_DB" == "" ]; then
	docker run --name $DOCKER_NAME -p 5432:5432 -e POSTGRES_PASSWORD=pa55word -d postgres
else
	docker start $DOCKER_NAME
fi
