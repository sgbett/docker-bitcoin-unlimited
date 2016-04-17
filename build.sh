#!/bin/bash

# Building image
docker build -t docker-bitcoin-unlimited .

# Saving image
echo Saving image...
rm -f docker-bitcoin-unlimited_*.tar.bz2
docker save docker-bitcoin-unlimited | bzip2 -9 > docker-bitcoin-unlimited_`date +%Y%m%d%H%M%S`.tar.bz2
