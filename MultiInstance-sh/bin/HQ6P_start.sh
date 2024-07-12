#!/bin/bash
#Global Variable
QMNAME=HQ6P
MQHA_BIN=/MQHA/bin

#WMQ Channel start
echo -e "\n$QMNAME Channel Starting"
$MQHA_BIN/hamqm_chl $QMNAME start
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: Could not start $QMNAME Channel"
  exit $rc
fi

#MTE Adapter start
echo -e "\nMTE Adapter starting..."
/MQHA/mte/adapter/conf/shell/mea_adt $QMNAME start

#MTE Control Center Agent start
echo -e "\nMTE Control Center Agent Starting."
#$MQHA_BIN/hamteagent_op start
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: Could not start MTE Agent"
  exit $rc
fi
exit 0
