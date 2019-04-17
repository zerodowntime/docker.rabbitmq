FROM zerodowntime/centos

RUN yum -y install \
  epel-release

RUN yum -y install https://github.com/rabbitmq/erlang-rpm/releases/download/v20.3.6/erlang-20.3.6-1.el7.centos.x86_64.rpm
RUN yum -y install https://github.com/rabbitmq/rabbitmq-server/releases/download/v3.7.13/rabbitmq-server-3.7.13-1.el7.noarch.rpm

VOLUME /data
WORKDIR /data

COPY confd/templates  /etc/confd/templates
COPY confd/conf.d     /etc/confd/conf.d
COPY docker-entrypoint.sh /usr/local/bin/

COPY liveness-probe.sh /opt/liveness-probe.sh
COPY readiness-probe.sh /opt/readiness-probe.sh

RUN chmod a+x /usr/local/bin/docker-entrypoint.sh

ENV LANG=C.UTF-8 LANGUAGE=C.UTF-8 LC_ALL=en_US.UTF-8

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["rabbitmq-server"]
EXPOSE 4369 5671 5672 25672
