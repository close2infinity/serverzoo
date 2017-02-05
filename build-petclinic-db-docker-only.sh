#!/usr/bin/env bash

# Delete the init container if it exists:
docker rm -f petclinic-db-init

if [ ! -d build/docker ]; then
    mkdir build/docker
fi
chmod -R ugo+rw build/docker

# Create the init container with an empty MySQL database:
docker run --name petclinic-db-init -p33306:3306 -e MYSQL_ROOT_PASSWORD=mysql -e MYSQL_DATABASE=petclinic -d mysql:5.7

# This is a workaround for a persistent MySQL problem (the server opens the
# port before being able to serve actual requests:
sleep 18

# Run migrations on the container:
flyway migrate -configFile=build/petclinic-example/src/main/resources/db/mysql/flyway.conf
docker stop petclinic-db-init

# Create a new Docker image containing the migrated database file. The image is
# tagged with the MD5 checksum of the migration files, so we may skip the whole
# process if migration files haven't changed:
docker cp petclinic-db-init:/var/lib/mysql ./build/docker/mysql-data
cp Dockerfile-db build/docker/Dockerfile
docker build -t close2infinity/petclinicdb:MD5_$(<build/distributions/spring-petclinic-1.4.2-migration.zip.MD5) build/docker
