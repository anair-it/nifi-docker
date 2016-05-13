FROM alpine
MAINTAINER Anoop Nair<anoopnair.it@gmail.com>

LABEL description="Build nifi image on Alpine Linux"

ENV JAVA_HOME /usr/lib/jvm/java-1.7-openjdk
ENV PATH $JAVA_HOME/bin:$PATH
ENV NIFI_VERSION 0.6.1
ENV NIFI_HOME /opt/nifi

RUN apk --update add bash git wget ca-certificates sudo openssh rsync openjdk7 && \
  rm -rf /var/cache/apk/* && \
  rm -rf /opt  && \
  mkdir -p /opt 

# Download and Install nifi
RUN wget -q http://www.webhostingjams.com/mirror/apache/nifi/$NIFI_VERSION/nifi-$NIFI_VERSION-bin.tar.gz && \
   tar xzf nifi-$NIFI_VERSION-bin.tar.gz -C /opt/ && \
   ln -s /opt/nifi-$NIFI_VERSION $NIFI_HOME && \
   rm nifi-$NIFI_VERSION-bin.tar.gz && \ 
   sed -i -e "s|^nifi.ui.banner.text=.*$$|nifi.ui.banner.text=My Docker NiFi $NIFI_VERSION|" $NIFI_HOME/conf/nifi.properties && \ 
   mkdir $NIFI_HOME/database_repository && \
   mkdir $NIFI_HOME/flowfile_repository && \
   mkdir $NIFI_HOME/content_repository && \
   mkdir $NIFI_HOME/provenance_repository && \
   mkdir $NIFI_HOME/xsl && \
   mkdir $NIFI_HOME/extra_lib

COPY extra_lib/* $NIFI_HOME/extra_lib/

VOLUME ["$NIFI_HOME/conf", "$NIFI_HOME/database_repository", "$NIFI_HOME/flowfile_repository", "$NIFI_HOME/content_repository", "$NIFI_HOME/provenance_repository"]

# Nifi Web port
EXPOSE 8080

WORKDIR $NIFI_HOME

CMD ["bin/nifi.sh", "run"]
