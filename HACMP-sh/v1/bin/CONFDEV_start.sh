#!/bin/ksh
#Global Variable
MQUSER=mqm
BKUSER=mqsi
QMNAME=CONFDEV
BKNAME=CONFIGMGR_DEV
DBINST=
DBNAME=

MQHA_BIN=/MQHA/bin

#MQ, WMQI, DB2 start
echo "$QMNAME EAI Component Stating(WMB, WMQ )"
$MQHA_BIN/hamqsi_start_cfgmgr_as $QMNAME $BKUSER $BKNAME
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: Could not start $QMNAME EAI Component"
  exit $rc
fi

#WMQ Channel start
echo "\n$QMNAME Channel Starting"
su $MQUSER -c "$MQHA_BIN/hamqm_chl $QMNAME start"
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: Could not start $QMNAME Channel"
  exit $rc
fi


#MQ Trigger Monitor Start
#echo "\n[$QMNAME] Trigger Monitor starting"
#su $MQUSER -c "/MQHA/bin/hamqm_trm $QMNAME start"
#rc=$?
#if [ $rc -ne 0 ]
#then
#  echo "(ERROR) ${0}: Could not start WMQ Trigger Monitor"
#  exit $rc
#fi

#MTE Control Center Agent start
echo "\nMTE Control Center Agent Starting."
su $MQUSER -c "$MQHA_BIN/hamteagent_op start"
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: Could not start MTE Agent"
  exit $rc
fi

exit 0
