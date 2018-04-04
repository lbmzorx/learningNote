/etc/init.d/nginx
#! /bin/bash
# Description: Startup script for webserver on CentOS. cp it in /etc/init.d and
# chkconfig --add nginx && chkconfig nginx on
# then you can use server command control nginx
#
# chkconfig: 2345 08 99
# description: Starts, stops nginx

set -e
PATH=$PATH:/usr/local/nginx/sbin/
DESC="nginx daemon"
NAME=nginx
DAEMON=/usr/local/nginx/sbin/$NAME
CONFIGFILE=/usr/local/nginx/conf/nginx.conf
PIDFILE=/var/run/nginx.pid
SCRIPTNAME=/etc/init.d/$NAME

# Gracefully exit if the package has been removed.
test -x $DAEMON || exit 0

d_start() {
$DAEMON -c $CONFIGFILE || echo -n " already running"
}

d_stop() {
kill -QUIT `cat $PIDFILE` || echo -n " not running"
}

d_reload() {
kill -HUP `cat $PIDFILE` || echo -n " can't reload"
}

case "$1" in
start)
echo -n "Starting $DESC: $NAME"
d_start
echo "."
;;
stop)
echo -n "Stopping $DESC: $NAME"
d_stop
echo "."
;;
reload)
echo -n "Reloading $DESC configuration..."
d_reload
echo "reloaded."
;;
restart)
echo -n "Restarting $DESC: $NAME"
d_stop
sleep 1
d_start
echo "."
;;
*)
echo "Usage: $SCRIPTNAME {start|stop|restart|force-reload}" >&2
exit 3
;;
esac
exit 0