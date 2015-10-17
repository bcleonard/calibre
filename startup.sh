#!/bin/bash

#
# add crontab for root
#
crontab /scripts/crontab

#
# start crond
#
/usr/sbin/crond

#
# start calibre-server
#
/usr/bin/calibre-server --with-library /data/library
