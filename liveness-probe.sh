#!/bin/sh

RESULT=$(curl --silent --show-error --fail "http://${RABBITMQ_MONITORING_USER}:{$RABBITMQ_MONITORING_PASS}@127.0.0.1:15672/api/healthchecks/node")
test "${RESULT}" = '{"status":"ok"}'
