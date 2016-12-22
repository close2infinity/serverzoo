#!/usr/bin/env bash

DB_IMAGE_NAME=close2infinity/petclinicdb

# start up the database
docker-compose up -d mysql
# wait for DB to get initialized
sleep 15
# flyway container will find the running DB within the network and migrate its data
docker-compose up flyway
# TODO do we need any cleanup here?
# we are done, shut doe the DB as well
docker-compose stop
# push this as a new image for future use
docker commit `docker-compose ps -q mysql` ${DB_IMAGE_NAME}
# clean up everything
docker-compose rm -f
