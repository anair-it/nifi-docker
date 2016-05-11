# Nifi docker image
Build a nifi docker image on Alpine Linux distro.

## Version
- Nifi: 0.6.1

## Exposed ports
- Nifi web port: 8080

## Usage
Build the image and start a cluster with zookeeper, hbase, kafka and nifi:
-  Build anair/hadoop_alipine_base image. Refer hadoop-docker-lite project
- ``docker-compose up``

Destroy cluster:

- ``docker-compose stop``  OR
- Ctrl C

## Nifi UI
http://localhost:28080

## Notes
- Ensure kafka and hbase are running before starting nifi. If you don't need kafka and hbase, comment out the links section in docker-compose.yml.
- IBM MQ and Oracle client libraries are copied to /opt/nifi/extra_lib directory on the container. This allows Nifi flows to talk to IBM MQ and Oracle
- /opt/nifi/xsl directory is created to hold XSL documents for transformation. Use "volumes" in docker-compose.yml to mount a host xsl directory to the container /opt/nifi/xsl directory
