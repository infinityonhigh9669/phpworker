#!/bin/bash

# Fill in name of php daemon file and run as System Daemon /
PROG="server.php"

# Fill in the path of the php file
PROG_PATH="/usr/share/nginx/html/"
PROG_ARGS=""
PID_PATH="/var/run"

## If not already running start php daemon
start() {
    if [ -e "$PID_PATH/nohup php $PROG.pid" ]; then
        ## Program is running, exit with error.
        echo "Error! $PROG is currently running!" 1>&2
        exit 1
 else
        ## Change from /dev/null to something like /var/log/$PROG if you want to save output.

        cd $PROG_PATH
        #nohup php $PROG_PATH/$PROG > /dev/null &
	nohup php $PROG_PATH/$PROG start &

        echo "nohup php $PROG_PATH/$PROG started as system service"
        touch "$PID_PATH/nohup php $PROG.pid"

    fi
}

## If runinng kill php daemon
stop() {
    if [ -e "$PID_PATH/nohup php $PROG.pid" ]; then
        ## Program is running, so stop it

       kill $(ps aux | grep "php $PROG_PATH/$PROG" | awk '{print $2}')

        rm "$PID_PATH/nohup php $PROG.pid"

        echo "System service $PROG stopped"

    else
        ## Program is not running as system service, exit with error.
        echo "Error! $PROG not started!" 1>&2
        exit 1
    fi
}

        case "$1" in
 start)
        start
        exit 0
    ;;
    stop)
        stop
        exit 0
 ;;
    reload|restart|force-reload)
        stop
        start
        exit 0
                 ;;
    **)
        echo "Usage: $0 {start|stop|reload}" 1>&2
        exit 1
    ;;
esac