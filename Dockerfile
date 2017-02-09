FROM anapsix/alpine-java:latest

####
#### this Dockerfile is used to build the image that runs the petclinic app
####

WORKDIR /opt/petclinic
ADD build/petclinic-example/target/spring-petclinic-1.5.1.jar .
CMD java -Xdebug -Xnoagent -Xrunjdwp:transport=dt_socket,address=14441,server=y,suspend=n -jar spring-petclinic-1.5.1.jar
