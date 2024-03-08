#!/bin/sh

LIBNAME=/data/library
CALIBREDB=/opt/calibre/calibredb
CAL_OPT="list"
export LANG=en_US.UTF-8

OPTIND=1

if [ $# -ne 2 ]
then
  echo ""
  echo "usage: ${0} -i book_id_to_remove"
  echo ""
  exit 1
fi

#
# process command line arguments
#
while getopts "i:" opt
do
  case ${opt} in
    i)  ID=${OPTARG}
        ;;
    esac
done
#
# get info about book from the library
#
${CALIBREDB} list --with-library="$LIBNAME" -s 'id:"='"$ID"'"' --fields=all --for-machine

