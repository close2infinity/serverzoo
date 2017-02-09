FROM anapsix/alpine-java:latest

####
#### this Dockerfile is used to build the image that runs the petclinic app
####

WORKDIR /opt/petclinic
ADD target/spring-petclinic-1.4.2.jar .
CMD java -Xdebug -Xnoagent -Xrunjdwp:transport=dt_socket,address=14441,server=y,suspend=n -jar spring-petclinic-1.4.2.jar
