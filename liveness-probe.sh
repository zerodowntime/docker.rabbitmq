#!/bin/sh

RESULT=$(curl --silent --show-error --fail "http://${RABBITMQ_DEFAULT_USER}:{$RABBITMQ_DEFAULT_PASS}@127.0.0.1:15672/api/healthchecks/node")
test "${RESULT}" = '{"status":"ok"}'
