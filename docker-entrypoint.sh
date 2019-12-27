#!/bin/bash
set -eu

if [ -z ${MEMORY_LIMIT_IN_BYTES:+ok} ]; then
  export MEMORY_LIMIT_IN_BYTES="$(( $(cat /sys/fs/cgroup/memory/memory.limit_in_bytes) / 10 * 9 ))"
fi 

touch /var/lib/rabbitmq/.start

export RABBITMQ_PEER_DISCOVERY_BACKEND=rabbit_peer_discovery_k8s
export RABBITMQ_K8S_SERVICE_NAME=rabbitmq-internal

confd -onetime -log-level debug || exit 2

export RABBITMQ_LOGS=- # hyphen to print logs to stdout

exec su-exec rabbitmq "$@"
