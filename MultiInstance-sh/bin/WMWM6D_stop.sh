#!/bin/bash
#Global Variable
QMNAME=WMWM6D
MQHA_BIN=/MQHA/bin
TIMEOUT=30

#MTE Control Center Agent stop
echo -e "\nMTE Control Center Agent stopping."
#/MQHA/mte/GSWM/mteagent/agent stop
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
/MQHA/mte/GSSM/adapter/script/.stop_mepa.sh
/MQHA/mte/GSWM/adapter/script/.stop_mepa.sh

exit 0
