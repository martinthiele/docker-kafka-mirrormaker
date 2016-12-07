FROM jeanblanchard/busybox-java:8

ENV KAFKA_VERSION=0.9.0.0
ENV KAFKA_RELEASE="http://apache.mirrors.spacedump.net/kafka/${KAFKA_VERSION}/kafka_2.10-${KAFKA_VERSION}.tgz"
ENV KAFKA_FILE="/tmp/kafka.tar.gz"

RUN DEBIAN_FRONTEND="noninteractive" \
    mkdir -p /tmp/kafka && \
    curl -Lo $KAFKA_FILE $KAFKA_RELEASE && \
    gunzip < $KAFKA_FILE | tar -C /tmp/kafka -xvf - && \
    mv /tmp/kafka/* /opt/kafka && \
    ls /opt/kafka/bin

USER root

ADD scripts/mirrormaker.sh mirrormaker.sh

ENTRYPOINT ["sh", "-ex", "./mirrormaker.sh"]
