#!/bin/bash
NAME=docker-bitcoin-unlimited
/etc/init.d/${NAME} stop
# rm -f /etc/init.d/${NAME} 2>&1 || true
docker rmi ${NAME}
