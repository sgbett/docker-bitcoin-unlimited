#!/bin/bash
NAME=docker-bitcoin-unlimited
cd /opt/${NAME}
IMAGE=`ls ${NAME}_*.tgz`
VERSION=`echo ${IMAGE} | sed "s@${NAME}_\(.*\)\.tgz@\1@"`
gunzip -c /opt/${NAME}/${IMAGE} | docker load
/etc/init.d/${NAME} start
