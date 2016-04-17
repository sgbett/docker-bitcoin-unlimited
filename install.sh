#!/bin/bash
NAME=docker-bitcoin-unlimited
cd /opt/${NAME}
IMAGE=`ls ${NAME}_*.tgz`
VERSION=`echo ${IMAGE} | sed "s@${NAME}_\(.*\)\.tar\.bz2@\1@"`
bunzip2 -c /opt/${NAME}/${IMAGE} | docker load
update-rc.d ${NAME} defaults
/etc/init.d/${NAME} start
