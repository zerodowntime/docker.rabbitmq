#!/bin/bash
set -eu

if [ -z ${MEMORY_LIMIT_IN_BYTES:+ok} ]; then
  export MEMORY_LIMIT_IN_BYTES="$(( $(cat /sys/fs/cgroup/memory/memory.limit_in_bytes) / 10 * 9 ))"
fi 

touch /var/lib/rabbitmq/.start

confd -onetime -log-level debug -backend env || exit 2
chown -R rabbitmq:rabbitmq "$RABBITMQ_DATA_DIR"

exec su-exec rabbitmq "$@"
