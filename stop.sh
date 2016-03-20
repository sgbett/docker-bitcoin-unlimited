#!/bin/bash
 # Stopping the container
docker stop docker-bitcoin-unlimited >/dev/null 2>&1 || true
 # Removing the container
docker rm docker-bitcoin-unlimited >/dev/null 2>&1 || true
