#!/usr/bin/bash

# OPTIONS
LIBRARY_DIR="/data/library"
BOOK_LOCATION="${LIBRARY_DIR}"
CALIBREDB="/opt/calibre/calibredb"
EBOOKMETA="/opt/calibre/ebook-meta"
SUCCESS=0

# /opt/calibre/calibredb list --with-library=/data/library -s 'id:"=500"' --fields=formats --for-machine | jq '.[].formats' | sed -n '2p' | cut -d\" -f2

# find all directories that have metadata which means they are a book directory
find "$BOOK_LOCATION" -type f -name "metadata.opf" -print0 | sort | while IFS= read -r -d '' file
do
  DN=`dirname "${file}"`

  # if the cover exists skip and move on
  if [ -f "${DN}/cover.jpg" ]
  then
    continue
  fi

  # if this book is not in the library skip and move on
  ID=`echo "${DN}" | awk -F\( '{print $NF}' | cut -d\) -f1`
  re='^[0-9]+$'
  if ! [[ ${ID} =~ $re ]]
  then
    continue
  fi

  BOOKFILE=`${CALIBREDB} list --with-library="$LIBRARY_DIR" -s 'id:"='"$ID"'"' --fields=formats --for-machine | jq '.[].formats' | sed -n '2p' | cut -d\" -f2`
  DN=`dirname "${BOOKFILE}"`
  FN=`basename "${BOOKFILE}"`
  BFN="${FN%.*}"
#  echo $BOOKFILE
#  echo "DN:	$DN"
#  echo "FN:	$BFN"

  if [ -f "${DN}/${BFN}.epub" ]
  then
    CFN="${DN}/${BFN}.epub"
  elif [ -f "${DN}/${BFN}.pdf" ]
  then
    CFN="${DN}/${BFN}.pdf"
  elif [ -f "${DN}/${BFN}.cbr" ]
  then
    CFN="${DN}/${BFN}.cbr"
  elif [ -f "${DN}/${BFN}.cbz" ]
  then
    CFN="${DN}/${BFN}.mobi"
  elif [ -f "${DN}/${BFN}.mobi" ]
  then
    CFN="${DN}/${BFN}.mobi"
  elif [ -f "${DN}/${BFN}.chm" ]
  then
    CFN="${DN}/${BFN}.chm"
  else
    echo "ERROR ID ${ID} NO MATCHING epub/pdf/cbr/cbz/mobi/chm FILE FOUND, SKIPPING"
    echo "ERROR ID ${ID} METADATA FILE:    ${file}"
    echo "ERROR ID ${ID} BOOKFILE:         ${BOOKFILE}"
    echo "ERROR ID ${ID} DIRECTORY NAME:   ${DN}"
    echo "ERROR ID ${ID} FILENAME:         ${FN}"
    echo "ERROR ID ${ID} FILENAME WOUTEXT: ${BFN}"
    continue
  fi

  # extrack the cover
  ${EBOOKMETA} "${CFN}" --get-cover="${DN}/cover.jpg" > /dev/null 2>&1
  RC=$?

  if [ "$RC" -ne "$SUCCESS" ]
  then
    echo "ERROR COULD NOT EXTRACT COVER FROM ${DN}/${BFN}"
  else
    ${CALIBREDB} set_metadata --with-library="${LIBRARY_DIR}" ${ID} "${file}" > /dev/null 2>&1
    RC=$?

    if [ "$RC" -ne "$SUCCESS" ]
    then
      echo "ERROR COULD NOT SET BOOK METADATA ${ID} FROM ${file}"
    else
      echo "SUCCESSFULLY ADDED COVER FOR ${ID}"
    fi
  fi

done

#$IFS="$SAVEIFS"

