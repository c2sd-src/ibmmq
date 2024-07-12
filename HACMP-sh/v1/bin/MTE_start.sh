#!/bin/ksh
#Global Variable
MQUSER=mqm
QMNAME=MTE

MQHA_BIN=/MQHA/bin

#MQ start
echo "$QMNAME EAI Component Stating(WMQ)"
su - $MQUSER -c "$MQHA_BIN/hamqm_start $QMNAME"
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: Could not start $QMNAME EAI Component"
  exit $rc
fi

#WMQ Channel start
#echo "\n$QMNAME Channel Starting"
#su $MQUSER -c "$MQHA_BIN/hamqm_chl $QMNAME start"
#rc=$?
#if [ $rc -ne 0 ]
#then
#  echo "(ERROR) ${0}: Could not start $QMNAME Channel"
#  exit $rc
#fi

#DataTracker Tomcat-Engine Start
#su - $MQUSER -c "/mte/dtt/tomcat/bin/catalina.sh start"
#rc=$?
#if [ $rc -ne 0 ]
#then
#  echo "(ERROR) ${0}: Could not start Tomcat-Engine"
#  exit $rc
#fi

#DataTracker Loader Start
#su - $MQUSER -c "cd /mte/mqloader;loader.sh start"
#rc=$?
#if [ $rc -ne 0 ]
#then
#  echo "(ERROR) ${0}: Could not start Loader"
#  exit $rc
#fi

#MTE Control Center Server start
#echo "\nMTE Control Center Server Starting."
#su - $MQUSER -c "cd /mte/mteserver;server start"
#rc=$?
#if [ $rc -ne 0 ]
#then
#  echo "(ERROR) ${0}: Could not start MTE Server"
#  exit $rc
#fi

#MTE Control Center Agent start
#echo "\nMTE Control Center Agent Starting."
#su - $MQUSER -c "$MQHA_BIN/hamteagent_op start"
#rc=$?
#if [ $rc -ne 0 ]
#then
#  echo "(ERROR) ${0}: Could not start MTE Agent"
#  exit $rc
#fi

#MQ Trigger Monitor Start
#echo "\n[$QMNAME] Trigger Monitor starting"
#su - $MQUSER -c "/MQHA/bin/hamqm_trm $QMNAME start"
#rc=$?
#if [ $rc -ne 0 ]
#then
#  echo "(ERROR) ${0}: Could not start WMQ Trigger Monitor"
#  exit $rc
#fi
#
exit 0
