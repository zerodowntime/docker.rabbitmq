#!/bin/bash
set -eu

if [ -z ${MEMORY_LIMIT_IN_BYTES:+ok} ]; then
  export MEMORY_LIMIT_IN_BYTES="$(( $(cat /sys/fs/cgroup/memory/memory.limit_in_bytes) / 10 * 9 ))"
fi 


confd -onetime || exit 2

export RABBITMQ_LOGS=- # hyphen to print logs to stdout

exec su-exec rabbitmq "$@"
