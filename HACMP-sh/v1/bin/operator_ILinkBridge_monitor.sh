#!/bin/ksh

#Process Monitor start
HOST=`hostname`

cd $ILINK_BRIDGE_HOME
if [ `ls -l core* | wc -l ` -ne 0 ]
then
  #plog GWProcess 3 "${HOST} java dump �߻� ��ȭ��� : (1��) �̼���D 010-3007-1110 (2��) ������K 010-4329-3707 "
  echo "�����߻�"
  exit $rc
fi

