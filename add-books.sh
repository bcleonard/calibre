#!/bin/sh

DIRNAME=/data/addbooks
LIBNAME=/data/library
CALIBREDB=/usr/bin/calibredb
CAL_OPT="add -d -1 -r"
STATUS_FILE=/data/add-books.is.running
export LANG=en_US.UTF-8

if [ -f ${STATUS_FILE} ]
then
  echo "${0} is curently running."
  echo "${STATUS_FILE} exists."
  exit 0
else
  cp /dev/null ${STATUS_FILE}
fi

${CALIBREDB} ${CAL_OPT} --with-library=${LIBNAME} ${DIRNAME} > /dev/null 2>&1
EC=$?
if [ $EC -eq 0 ]
then
  /bin/rm -rf -- ${DIRNAME}/* > /dev/null 2>&1
fi

if [ -f ${STATUS_FILE} ]
then
  rm ${STATUS_FILE}
fi

