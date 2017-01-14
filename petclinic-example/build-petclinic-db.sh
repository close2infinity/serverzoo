#!/usr/bin/env bash
docker rm -f petclinic-db-init
if [ ! -d build/docker ]; then
    mkdir build/docker
fi
chmod -R ugo+rw build/docker
docker run --name petclinic-db-init -p33306:3306 -e MYSQL_ROOT_PASSWORD=mysql -e MYSQL_DATABASE=petclinic -d mysql:5.7
sleep 18
flyway migrate -configFile=src/main/resources/db/mysql/flyway.conf
docker stop petclinic-db-init
docker cp petclinic-db-init:/var/lib/mysql ./build/docker/mysql-data
cp src/main/resources/db/mysql/Dockerfile build/docker
docker build -t close2infinity/petclinicdb:MD5_$(<build/distributions/spring-petclinic-1.4.2-migration.zip.MD5) build/docker
