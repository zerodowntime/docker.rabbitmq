FROM zerodowntime/centos:7.6.1810

ARG ERLANG_VERSION
ARG RABBITMQ_VERSION

RUN yum -y install\
  epel-release\
  https://github.com/rabbitmq/erlang-rpm/releases/download/v$ERLANG_VERSION/erlang-$ERLANG_VERSION-1.el7.x86_64.rpm\
  https://github.com/rabbitmq/rabbitmq-server/releases/download/v$RABBITMQ_VERSION/rabbitmq-server-$RABBITMQ_VERSION-1.el7.noarch.rpm\
  && yum clean all\
  && rm -rf /var/cache/yum /var/tmp/* /tmp/*

VOLUME /data
WORKDIR /data

COPY confd/templates  /etc/confd/templates
COPY confd/conf.d     /etc/confd/conf.d
COPY docker-entrypoint.sh /

COPY liveness-probe.sh /opt/
COPY readiness-probe.sh /opt/

ENV LANG=C.UTF-8 LANGUAGE=C.UTF-8 LC_ALL=en_US.UTF-8

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["rabbitmq-server"]

EXPOSE 4369 5671 5672 25672
