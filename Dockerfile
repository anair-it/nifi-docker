FROM alpine
MAINTAINER Anoop Nair<anoopnair.it@gmail.com>

LABEL description="Build nifi 1.1.2 image on Alpine Linux"

ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk
ENV PATH $JAVA_HOME/bin:$PATH
ENV NIFI_VERSION 1.1.2
ENV NIFI_HOME /opt/nifi
ENV ES_VERSION 5.2.2
ENV XPACK_VERSION 5.0.1

RUN apk --update add bash git wget ca-certificates sudo openssh rsync openjdk8 zip && \
  rm -rf /var/cache/apk/* && \
  rm -rf /opt  && \
  mkdir -p /opt 

# Download and Install nifi
RUN wget -q http://apache.mesi.com.ar/nifi/$NIFI_VERSION/nifi-$NIFI_VERSION-bin.tar.gz && \
   tar xzf nifi-$NIFI_VERSION-bin.tar.gz -C /opt/ && \
   ln -s /opt/nifi-$NIFI_VERSION $NIFI_HOME && \
   rm nifi-$NIFI_VERSION-bin.tar.gz && \ 
   sed -i -e "s|^nifi.ui.banner.text=.*$$|nifi.ui.banner.text=My Docker NiFi - $NIFI_VERSION|" $NIFI_HOME/conf/nifi.properties && \ 
   mkdir $NIFI_HOME/database_repository && \
   mkdir $NIFI_HOME/flowfile_repository && \
   mkdir $NIFI_HOME/content_repository && \
   mkdir $NIFI_HOME/provenance_repository && \
   mkdir $NIFI_HOME/xsl && \
   mkdir $NIFI_HOME/extra_lib

COPY extra_lib/* $NIFI_HOME/extra_lib/

# Elasticsearch and xpack download. Refer: https://community.hortonworks.com/questions/81606/where-should-i-store-files-used-by-processors-in-a.html

RUN wget -q https://artifacts.elastic.co/downloads/packs/x-pack/x-pack-$XPACK_VERSION.zip && \
    unzip x-pack-$XPACK_VERSION.zip -d $NIFI_HOME/extra_lib && \
    wget -q https://artifacts.elastic.co/maven/org/elasticsearch/client/x-pack-transport/$XPACK_VERSION/x-pack-transport-$XPACK_VERSION.jar && \
    cp x-pack-transport-$XPACK_VERSION.jar $NIFI_HOME/extra_lib/ && \
    wget http://central.maven.org/maven2/org/elasticsearch/elasticsearch/$ES_VERSION/elasticsearch-$ES_VERSION.jar && \
    cp elasticsearch-$ES_VERSION.jar $NIFI_HOME/extra_lib/elasticsearch && \
    rm -rf $NIFI_HOME/extra_lib/kibana && \
    rm -rf $NIFI_HOME/extra_lib/logstash


VOLUME ["$NIFI_HOME/conf", "$NIFI_HOME/database_repository", "$NIFI_HOME/flowfile_repository", "$NIFI_HOME/content_repository", "$NIFI_HOME/provenance_repository"]

# Nifi Web port
EXPOSE 8080

WORKDIR $NIFI_HOME

CMD ["bin/nifi.sh", "run"]
