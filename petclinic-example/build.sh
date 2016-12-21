#!/usr/bin/env bash
docker rm -f petclinic-db-init
if [ ! -d target/docker ]; then
    mkdir target/docker
fi
chmod -R ugo+rw target/docker
docker run --name petclinic-db-init -p33306:3306 -e MYSQL_ROOT_PASSWORD=mysql -e MYSQL_DATABASE=petclinic -d mysql:5.7
sleep 18
flyway migrate -configFile=src/main/resources/db/mysql/flyway.conf
docker stop petclinic-db-init
docker cp petclinic-db-init:/var/lib/mysql ./target/docker/mysql-data
cp src/main/resources/db/mysql/Dockerfile target/docker
docker build -t close2infinity/petclinicdb target/docker
