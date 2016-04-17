#!/bin/bash

# Setting environment variables
BITCOIN_VERSION=0.12.0
RPCUSER=bitcoin
RPCPASS=654Q43GPvRayNpDbZL4rAdsW4GE2fSaejubcGcuwp1c4
RPCPORT=8332
BITCOIN_PORT=8333

# Stopping any existing container
docker stop docker-bitcoin-unlimited >/dev/null 2>&1 || true

# Removing any existing container
docker rm docker-bitcoin-unlimited >/dev/null 2>&1 || true

# Creating the network
docker network create bitcoin >/dev/null 2>&1 || true

# Determining where to host the volumes
HOST=`readlink -f .`
if [[ $EUID -eq 0 ]]; then
   HOST=/opt
fi

# Creating directories for hosting volumes
mkdir -p ${HOST}/docker-bitcoin-unlimited/home/bitcoin/.bitcoin
chown -R 1000:docker ${HOST}/docker-bitcoin-unlimited/home/bitcoin/.bitcoin
chmod -R 775 ${HOST}/docker-bitcoin-unlimited/home/bitcoin/.bitcoin

# Running the image
docker run -it -d --name docker-bitcoin-unlimited --net bitcoin -p $BITCOIN_PORT:$BITCOIN_PORT -v ${HOST}/docker-bitcoin-unlimited/home/bitcoin/.bitcoin:/home/bitcoin/.bitcoin docker-bitcoin-unlimited /bin/bash
