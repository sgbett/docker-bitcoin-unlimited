FROM phusion/baseimage:0.9.18
MAINTAINER Joe Ruether <jrruethe@gmail.com>

ENV RPCUSER bitcoin
ENV RPCPASS 654Q43GPvRayNpDbZL4rAdsW4GE2fSaejubcGcuwp1c4
ENV RPCPORT 58332

EXPOSE 58332

ADD http://www.bitcoinunlimited.info/downloads/bitcoinUnlimited-0.11.2-linux64.tar.gz /home/bitcoin/

RUN `# Creating user / Adjusting user permissions`                                                                                                                                                         && \
     (groupadd -g 1000 bitcoin || true)                                                                                                                                                                    && \
     ((useradd -u 1000 -g 1000 -p bitcoin -m bitcoin) ||                                                                                                                                                      \
      (usermod -u 1000 bitcoin && groupmod -g 1000 bitcoin))                                                                                                                                               && \
     chown -R bitcoin:bitcoin /home/bitcoin                                                                                                                                                                && \
                                                                                                                                                                                                              \
    `# Installing bitcoind daemon`                                                                                                                                                                         && \
     mkdir -p /etc/service/bitcoind                                                                                                                                                                        && \
     echo '#!/bin/sh' > /etc/service/bitcoind/run                                                                                                                                                          && \
     echo "exec /sbin/setuser bitcoin /home/bitcoin/bitcoinUnlimited-0.11.2/bin/bitcoind -server -txindex -rpcuser=$RPCUSER -rpcpassword=$RPCPASS -rpcport=$RPCPORT -reindex" >> /etc/service/bitcoind/run && \
     chmod 755 /etc/service/bitcoind/run                                                                                                                                                                   && \
                                                                                                                                                                                                              \
    `# Unpacking Bitcoin Executable`                                                                                                                                                                       && \
     cd /home/bitcoin/                                                                                                                                                                                     && \
     tar xzvf bitcoinUnlimited-0.11.2-linux64.tar.gz                                                                                                                                                       && \
     chown -R bitcoin:bitcoin .                                                                                                                                                                            && \
                                                                                                                                                                                                              \
    `# Adding block-height cronjob`                                                                                                                                                                        && \
     echo '#!/bin/sh -e' > /etc/cron.hourly/block-height                                                                                                                                                   && \
     echo 'logger block-height: $(' >> /etc/cron.hourly/block-height                                                                                                                                       && \
     echo "/home/bitcoin/bitcoinUnlimited-0.11.2/bin/bitcoin-cli -rpcuser=$RPCUSER -rpcpassword=$RPCPASS -rpcport=$RPCPORT getblockcount;" >> /etc/cron.hourly/block-height                                && \
     echo ')' >> /etc/cron.hourly/block-height                                                                                                                                                             && \
     chmod 755 /etc/cron.hourly/block-height                                                                                                                                                               && \
                                                                                                                                                                                                              \
    `# Fixing permission errors for volume`                                                                                                                                                                && \
     mkdir -p /home/bitcoin/.bitcoin                                                                                                                                                                       && \
     chown -R bitcoin:bitcoin /home/bitcoin/.bitcoin                                                                                                                                                       && \
     chmod -R 700 /home/bitcoin/.bitcoin                                                                                                                                                                  

VOLUME /home/bitcoin/.bitcoin

ENTRYPOINT ["/sbin/my_init"]
