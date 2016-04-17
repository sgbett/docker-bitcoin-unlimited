# docker-bitcoin-unlimited 2016-04-17 09:05:58 -0400
FROM phusion/baseimage:0.9.18
MAINTAINER jrruethe@gmail.com

ENV BITCOIN_VERSION 0.12.0
ENV RPCUSER bitcoin
ENV RPCPASS 654Q43GPvRayNpDbZL4rAdsW4GE2fSaejubcGcuwp1c4
ENV RPCPORT 8332
ENV BITCOIN_PORT 8333

EXPOSE $BITCOIN_PORT

COPY bitcoinUnlimited-$BITCOIN_VERSION-linux64.tar.gz /home/bitcoin/

COPY Dockerfile /Dockerfile
COPY Dockerfile.yml /Dockerfile.yml

RUN `# Creating user / Adjusting user permissions`                                                                                                                                                                                                                         && \
     (groupadd -g 1000 bitcoin || true)                                                                                                                                                                                                                                    && \
     ((useradd -u 1000 -g 1000 -p bitcoin -m bitcoin) ||                                                                                                                                                                                                                      \
      (usermod -u 1000 bitcoin && groupmod -g 1000 bitcoin))                                                                                                                                                                                                               && \
     mkdir -p /home/bitcoin                                                                                                                                                                                                                                                && \
     chown -R bitcoin:bitcoin /home/bitcoin /opt                                                                                                                                                                                                                           && \
                                                                                                                                                                                                                                                                              \
    `# Unpacking Bitcoin Executable`                                                                                                                                                                                                                                       && \
     cd /home/bitcoin/                                                                                                                                                                                                                                                     && \
     tar xzvf bitcoinUnlimited-$BITCOIN_VERSION-linux64.tar.gz                                                                                                                                                                                                             && \
     chown -R bitcoin:bitcoin .                                                                                                                                                                                                                                            && \
                                                                                                                                                                                                                                                                              \
    `# Installing bitcoind daemon`                                                                                                                                                                                                                                         && \
     mkdir -p /etc/service/bitcoind                                                                                                                                                                                                                                        && \
     echo "#!/bin/sh"                                                                                                                                                                                                                         >> /etc/service/bitcoind/run && \
     echo "exec /sbin/setuser bitcoin /home/bitcoin/bitcoinUnlimited-$BITCOIN_VERSION/bin/bitcoind -server -txindex -disablewallet -whitelist=255.255.255.0 -rpcallowip=0.0.0.0/0 -rpcuser=$RPCUSER -rpcpassword=$RPCPASS -rpcport=$RPCPORT " >> /etc/service/bitcoind/run && \
     chmod 755 /etc/service/bitcoind/run                                                                                                                                                                                                                                   && \
                                                                                                                                                                                                                                                                              \
    `# Adding block-height cronjob`                                                                                                                                                                                                                                        && \
     echo "#!/bin/sh -e"                                                                                                                            >> /etc/cron.hourly/block-height                                                                                       && \
     echo "logger block-height: \$("                                                                                                                >> /etc/cron.hourly/block-height                                                                                       && \
     echo "/home/bitcoin/bitcoinUnlimited-$BITCOIN_VERSION/bin/bitcoin-cli -rpcuser=$RPCUSER -rpcpassword=$RPCPASS -rpcport=$RPCPORT getblockcount" >> /etc/cron.hourly/block-height                                                                                       && \
     echo ")"                                                                                                                                       >> /etc/cron.hourly/block-height                                                                                       && \
     chmod 755 /etc/cron.hourly/block-height                                                                                                                                                                                                                               && \
                                                                                                                                                                                                                                                                              \
    `# Adding connection-count cronjob`                                                                                                                                                                                                                                    && \
     echo "#!/bin/sh -e"                                                                                                                                 >> /etc/cron.hourly/connection-count                                                                              && \
     echo "logger connection-count: \$("                                                                                                                 >> /etc/cron.hourly/connection-count                                                                              && \
     echo "/home/bitcoin/bitcoinUnlimited-$BITCOIN_VERSION/bin/bitcoin-cli -rpcuser=$RPCUSER -rpcpassword=$RPCPASS -rpcport=$RPCPORT getconnectioncount" >> /etc/cron.hourly/connection-count                                                                              && \
     echo ")"                                                                                                                                            >> /etc/cron.hourly/connection-count                                                                              && \
     chmod 755 /etc/cron.hourly/connection-count                                                                                                                                                                                                                           && \
                                                                                                                                                                                                                                                                              \
    `# Fixing permission errors for volume`                                                                                                                                                                                                                                && \
     mkdir -p /home/bitcoin/.bitcoin                                                                                                                                                                                                                                       && \
     chown -R bitcoin:bitcoin /home/bitcoin/.bitcoin                                                                                                                                                                                                                       && \
     chmod -R 700 /home/bitcoin/.bitcoin                                                                                                                                                                                                                                  

VOLUME /home/bitcoin/.bitcoin

ENTRYPOINT ["/sbin/my_init"]
CMD [""]
