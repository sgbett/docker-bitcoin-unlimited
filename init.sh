#!/bin/sh
### BEGIN INIT INFO
# Provides:          docker-bitcoin-unlimited
# Required-Start:    $docker
# Required-Stop:     $docker
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Description:       docker-bitcoin-unlimited
### END INIT INFO
 start()
{
  /opt/docker-bitcoin-unlimited/run.sh
}
 stop()
{
  /opt/docker-bitcoin-unlimited/stop.sh
}
 case "$1" in
  start)
    start
    ;;
  stop)
    stop
    ;;
  retart)
    stop
    start
    ;;
  *)
    echo "Usage: $0 {start|stop|restart}"
esac
