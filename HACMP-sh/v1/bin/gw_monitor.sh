#!/bin/ksh
MQHA_BIN=/MQHA/bin

#Process Monitor start
echo "Process Monitor start"
if [ `ls -l javacore* | wc -l ` -ne 0 OR `ls -l heapdump* | wc -l ` -ne 0 ]
then
  echo "GW java Process Err : Call ÀÌÀç½ÄD 010-3848-2399"
  exit $rc
fi

