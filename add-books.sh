#!/bin/sh

DIRNAME=/data/addbooks
LIBNAME=/data/library
CALIBREDB=/usr/bin/calibredb
CAL_OPT="add -1 -r"
export LANG=en_US.UTF-8

${CALIBREDB} ${CAL_OPT} --with-library=${LIBNAME} ${DIRNAME} > /dev/null 2>&1
EC=$?
if [ $EC -eq 0 ]
then
  /bin/rm -rf -- ${DIRNAME}/* > /dev/null 2>&1
fi
