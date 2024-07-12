#!/bin/bash
#Global Variable
QMNAME=HQ6P
MQHA_BIN=/MQHA/bin
TIMEOUT=30

#MTE Control Center Agent stop
echo -e "\nMTE Control Center Agent stopping."
#/MQHA/bin/hamteagent_op stop
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: Could not stop MTE Agent"
  exit $rc
fi

#MQ Channel stop
echo -e "\n$QMNAME Channel stopping"
$MQHA_BIN/hamqm_chl $QMNAME stop
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: Could not stop $QMNAME Channel"
  exit $rc
fi

#MTE Adapter stop
echo -e "\nMTE Adapter stopping..."
/MQHA/mte/adapter/conf/shell/mea_adt $QMNAME stop

exit 0
