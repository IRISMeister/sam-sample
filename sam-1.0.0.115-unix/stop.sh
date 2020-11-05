#!/bin/bash

# removing voluems (durable sys) as well.
docker-compose -p sam down -v

#Without this, cluster registration will fail on second run 
sudo chmod 777 config/prometheus/isc_*.yml

#revert them to initial (because I'm removing durable sys)
git checkout -- config/prometheus/isc_alert_rules.yml
git checkout -- config/prometheus/isc_prometheus.yml