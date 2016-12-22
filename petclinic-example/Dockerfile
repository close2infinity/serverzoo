FROM anapsix/alpine-java:latest
WORKDIR /opt/petclinic
ADD target/spring-petclinic-1.4.2.jar .
CMD java -Xdebug -Xnoagent -Xrunjdwp:transport=dt_socket,address=14441,server=y,suspend=n -jar spring-petclinic-1.4.2.jar
