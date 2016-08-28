FROM maven:latest
MAINTAINER Jeremie Lesage <info@jeci.fr>

WORKDIR /root

ENV JBAKE_VERSION 2.4.0.1

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
		      rsync \
    && rm -rf /var/lib/apt/lists/*

RUN git clone -n https://github.com/jeci-sarl/jbake.git jbake \
    && cd jbake \
    && git checkout origin/v$JBAKE_VERSION
WORKDIR /root/jbake

RUN mvn package -Dmaven.test.skip=true \
    && unzip /root/jbake/dist/jbake-$JBAKE_VERSION-bin.zip -d /opt

RUN mkdir -p "/data"
WORKDIR /data
RUN rm -rf /root/jbake/

ENV JBAKE_HOME /opt/jbake-$JBAKE_VERSION/
ENV PATH $JBAKE_HOME/bin:$PATH


RUN jbake -i

VOLUME "/data"
EXPOSE 8820

ENTRYPOINT ["jbake"]
CMD ["-b -s"]
