#!/bin/bash
 NAME=docker-bitcoin-unlimited
IMAGE=`ls ${NAME}_*.tgz`
VERSION=`echo ${IMAGE} | sed "s@${NAME}_\(.*\)\.tar\.bz2@\1@"`
 rm -f ${NAME}_*.deb
 fpm -s dir -t deb                   \
  --name ${NAME}                    \
  --version ${VERSION}              \
  --maintainer 'jrruethe@gmail.com'          \
  --vendor 'jrruethe@gmail.com'              \
  --license 'GPLv3+'                \
  --description ${NAME}             \
  --depends 'docker-engine > 1.9.0' \
  --after-install ./install.sh      \
  --before-remove ./uninstall.sh    \
  ./${IMAGE}=/opt/${NAME}/${IMAGE}  \
  ./run.sh=/opt/${NAME}/run.sh      \
  ./stop.sh=/opt/${NAME}/stop.sh    \
  ./init.sh=/etc/init.d/${NAME}
 dpkg --info ${NAME}_${VERSION}_amd64.deb
dpkg --contents ${NAME}_${VERSION}_amd64.deb
