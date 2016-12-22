#!/usr/bin/env bash

DB_IMAGE_NAME=close2infinity/petclinicdb
TMP_DATA_DIR=.tmp-mysql-data

# start up the database
docker-compose up -d mysql
# wait for DB to get initialized
sleep 15
# flyway container will find the running DB within the network and migrate its data
docker-compose up flyway
# we are done, shut down the DB as well
docker-compose stop
# unfortunately, we cannot simply commit the result as the content of volumes is ignored - therefore we use cp
docker cp `docker-compose ps -q mysql`:/var/lib/mysql ${TMP_DATA_DIR}
docker build --build-arg data_directory=${TMP_DATA_DIR} -t ${DB_IMAGE_NAME} .
# clean up everything
docker-compose rm -f
rm -rf ${TMP_DATA_DIR}
