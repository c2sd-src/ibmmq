#!/bin/ksh

#Process Monitor start
HOST=`hostname`

cd $ILINK_BRIDGE_HOME
if [ `ls -l core* | wc -l ` -ne 0 ]
then
  #plog GWProcess 3 "${HOST} java dump 발생 전화요망 : (1차) 이성민D 010-3007-1110 (2차) 하태현K 010-4329-3707 "
  echo "오류발생"
  exit $rc
fi

