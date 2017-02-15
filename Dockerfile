FROM ubuntu:14.04
MAINTAINER Eli Ribble <eli@authentise.com>

# update
RUN apt-get -y update

# install utilities
RUN apt-get -y install wget

# installation : java JDK
RUN apt-get install -y openjdk-7-jdk
ENV JAVA_HOME /usr/lib/jvm/java-1.7.0-openjdk-amd64

# install jboss
RUN wget -O /tmp/jboss-as-7.1.1.Final.tar.gz \
    http://download.jboss.org/jbossas/7.1/jboss-as-7.1.1.Final/jboss-as-7.1.1.Final.tar.gz && \
    tar zxvf /tmp/jboss-as-7.1.1.Final.tar.gz -C /opt

# configuration
RUN sed -i -r 's/jboss.bind.address.management:127.0.0.1/jboss.bind.address.management:0.0.0.0/' \
    /opt/jboss-as-7.1.1.Final/standalone/configuration/standalone.xml

# clean
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# expose ports
EXPOSE 8080 9990

# add help
ADD help help.txt /
RUN chmod 755 /help

# script to start the container
ADD jboss_run.sh /jboss_run.sh
RUN chmod 755 /*.sh
CMD ["/jboss_run.sh"]
