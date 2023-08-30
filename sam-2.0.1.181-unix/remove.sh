#!/bin/bash

docker-compose -p sam down --volumes
sudo rm config/prometheus/*.yml
cp org/*.yml config/prometheus/
