FROM jeci/centos_deployer_maven
MAINTAINER Jeremie Lesage <info@jeci.fr>

RUN yum -y install unzip git \
    && yum clean all

WORKDIR /root

ENV JBAKE_VERSION 2.4.0.1

RUN git clone -n https://github.com/jeci-sarl/jbake.git jbake \
    && cd jbake \
    && git checkout origin/v$JBAKE_VERSION \
    && mvn package -Dmaven.test.skip=true \
    && unzip /root/jbake/dist/dist/jbake-$JBAKE_VERSION-bin.zip -d /opt \
    && rm -f /root/jbake/

ENV JBAKE_HOME /opt/jbake-$JBAKE_VERSION/
ENV PATH $JBAKE_HOME/bin:$PATH

RUN mkdir -p "/data"
WORKDIR /data

RUN jbake -i

VOLUME "/data"
EXPOSE 8820

ENTRYPOINT ["jbake"]
CMD ["-b -s"]
