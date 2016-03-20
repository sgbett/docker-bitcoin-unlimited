#!/bin/bash

# Building image
docker build -t docker-bitcoin-unlimited .

# Saving image
echo Saving image...
rm -f docker-bitcoin-unlimited_*.tgz
docker save docker-bitcoin-unlimited | gzip -9 > docker-bitcoin-unlimited_`date +%Y%m%d%H%M%S`.tgz
