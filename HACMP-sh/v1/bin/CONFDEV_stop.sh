#!/bin/ksh
#Global Variable
MQUSER=mqm
BKUSER=mqsi
QMNAME=CONFDEV
BKNAME=CONFIGMGR_DEV
DBINST=
DBNAME=

MQHA_BIN=/MQHA/bin
TIMEOUT=30

#MTE Control Center Agent stop
echo "\nMTE Control Center Agent stopping."
su $MQUSER -c "/MQHA/bin/hamteagent_op stop"
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: Could not stop MTE Agent"
  exit $rc
fi

#WMQ Channel stop
echo "\n$QMNAME Channel stopping"
su $MQUSER -c "$MQHA_BIN/hamqm_chl $QMNAME stop"
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: Could not stop $QMNAME Channel"
  exit $rc
fi

#MQ Trigger Monitor Stop
#echo "\n[$QMNAME] Trigger Monitor stopping"
#su $MQUSER -c "/MQHA/bin/hamqm_trm $QMNAME stop"
#rc=$?
#if [ $rc -ne 0 ]
#then
#  echo "(ERROR) ${0}: Could not stop WMQ Trigger Monitor"
#  exit $rc
#fi

#MQ, WMQI, DB2 stop
echo "$QMNAME EAI Component Stopping(WMB, WMQ) in $TIMEOUT SEC."
$MQHA_BIN/hamqsi_stop_cfgmgr_as $QMNAME $BKUSER $BKNAME $TIMEOUT 
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: Could not stop $QMNAME EAI Component"
  exit $rc
fi


exit 0
