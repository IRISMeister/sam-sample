#!/bin/bash

# removing voluems
docker-compose -p sam down -v

#revert them to initial state (because I'm removing sam database)
git checkout -- config/prometheus/isc_alert_rules.yml
git checkout -- config/prometheus/isc_prometheus.yml