#!/usr/bin/env bash

####
#### this script is used to build the mysql image which already has petclinic data in it
####

DB_IMAGE_NAME=petclinic-db
TMP_DATA_DIR=build/tmp-mysql-data

# start up the database
docker-compose --file docker-compose-mysql-image-builder.yml up -d mysql
# wait for DB to get initialized
sleep 15
# flyway container will find the running DB within the network and migrate its data
docker-compose --file docker-compose-mysql-image-builder.yml up flyway
# we are done, shut down the DB as well
docker-compose stop

# unfortunately, we cannot simply commit the result as the content of volumes is ignored - therefore we use cp
docker cp `docker-compose --file docker-compose-mysql-image-builder.yml ps -q mysql`:/var/lib/mysql ${TMP_DATA_DIR}
# the image is tagged with the MD5 checksum of the migration files, so we may skip the whole process if migration files haven't changed
docker build --build-arg data_directory=${TMP_DATA_DIR} --tag ${DB_IMAGE_NAME}:MD5_$(<build/distributions/spring-petclinic-1.4.2-migration.zip.MD5) --file Dockerfile-db-compose .

# clean up everything
docker-compose --file docker-compose-mysql-image-builder.yml rm -f
rm -rf ${TMP_DATA_DIR}
