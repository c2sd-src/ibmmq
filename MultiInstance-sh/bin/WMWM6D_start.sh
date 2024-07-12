#!/bin/bash
#Global Variable
MQHA_BIN=/MQHA/bin
QMNAME=WMWM6D

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
/MQHA/mte/GSSM/adapter/script/.start_online.sh
/MQHA/mte/GSWM/adapter/script/.start_online.sh

#MTE Agent start
echo -e "\nMTE Control Center Agent Starting."
#/MQHA/mte/GSWM/mteagent/agent start
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: Could not start MTE Agent"
  exit $rc
fi

exit 0
