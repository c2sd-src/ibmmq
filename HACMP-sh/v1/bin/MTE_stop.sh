#!/bin/ksh
#Global Variable
MQUSER=mqm
QMNAME=MTE

MQHA_BIN=/MQHA/bin
TIMEOUT=30

#MTE Control Center Agent stop
#echo "\nMTE Control Center Agent stopping."
#su - $MQUSER -c "/MQHA/bin/hamteagent_op stop"
#rc=$?
#if [ $rc -ne 0 ]
#then
#  echo "(ERROR) ${0}: Could not stop MTE Agent"
#  exit $rc
#fi

#MTE Control Center Server stop
#echo "\nMTE Control Center Server stopping."
#su - $MQUSER -c "cd /mte/mteserver;server stop"
#rc=$?
#if [ $rc -ne 0 ]
#then
#  echo "(ERROR) ${0}: Could not stop MTE Server"
#  exit $rc
#fi

#DataTracker Loader Stop
#su - $MQUSER -c "cd /mte/mqloader;loader.sh stop"
#rc=$?
#if [ $rc -ne 0 ]
#then
#  echo "(ERROR) ${0}: Could not stop Loader"
#  exit $rc
#fi

#DataTracker Tomcat-Engine Stop
#su - $MQUSER -c "/mte/dtt/tomcat/bin/catalina.sh stop"
#rc=$?
#if [ $rc -ne 0 ]
#then
#  echo "(ERROR) ${0}: Could not stop Tomcat-Engine"
#  exit $rc
#fi

#WMQ Channel stop
#echo "\n$QMNAME Channel stopping"
#su $MQUSER -c "$MQHA_BIN/hamqm_chl $QMNAME stop"
#rc=$?
#if [ $rc -ne 0 ]
#then
#  echo "(ERROR) ${0}: Could not stop $QMNAME Channel"
#  exit $rc
#fi

#MQ Trigger Monitor Stop
#echo "\n[$QMNAME] Trigger Monitor stopping"
#su - $MQUSER -c "/MQHA/bin/hamqm_trm $QMNAME stop"
#rc=$?
#if [ $rc -ne 0 ]
#then
#  echo "(ERROR) ${0}: Could not stop WMQ Trigger Monitor"
#  exit $rc
#fi


#MQ stop
echo "$QMNAME EAI Component Stopping(WMQ) in $TIMEOUT SEC."
su - $MQUSER -c "$MQHA_BIN/hamqm_stop $QMNAME $TIMEOUT"
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: Could not stop $QMNAME EAI Component"
  exit $rc
fi


exit 0
