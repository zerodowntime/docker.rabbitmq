FROM zerodowntime/centos:7.6.1810

ARG ERLANG_VERSION
ARG RABBITMQ_VERSION

ENV RABBITMQ_DATA_DIR=/var/lib/rabbitmq
ENV HOME $RABBITMQ_DATA_DIR
ENV RABBITMQ_PEER_DISCOVERY_BACKEND=rabbit_peer_discovery_k8s
# hyphen to print logs to stdout
ENV RABBITMQ_LOGS=- 
ENV LANG=C.UTF-8 LANGUAGE=C.UTF-8 LC_ALL=en_US.UTF-8

RUN \
  groupadd --gid 998 --system rabbitmq \
  && useradd --uid 998 --system --home-dir "$RABBITMQ_DATA_DIR" --gid rabbitmq rabbitmq \
  && mkdir -p "$RABBITMQ_DATA_DIR" \
  && chown -R rabbitmq:rabbitmq "$RABBITMQ_DATA_DIR" \
  && chmod 755 "$RABBITMQ_DATA_DIR"

COPY confd/templates  /etc/confd/templates
COPY confd/conf.d     /etc/confd/conf.d
COPY docker-entrypoint.sh /

COPY liveness-probe.sh /opt/
COPY readiness-probe.sh /opt/

RUN yum -y install \
  epel-release \
  https://github.com/rabbitmq/erlang-rpm/releases/download/v$ERLANG_VERSION/erlang-$ERLANG_VERSION-1.el7.x86_64.rpm \
  https://github.com/rabbitmq/rabbitmq-server/releases/download/v$RABBITMQ_VERSION/rabbitmq-server-$RABBITMQ_VERSION-1.el7.noarch.rpm \
  && yum clean all \
  && rm -rf /var/cache/yum /var/tmp/* /tmp/*

VOLUME $RABBITMQ_DATA_DIR

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 4369 5671 5672 25672
CMD ["rabbitmq-server"]
