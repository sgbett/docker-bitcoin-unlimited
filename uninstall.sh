#!/bin/bash
NAME=docker-bitcoin-unlimited
/etc/init.d/${NAME} stop
update-rc.d -f ${NAME} remove
docker rmi ${NAME}
