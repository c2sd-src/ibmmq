#!/bin/ksh
#Global Variable
MQUSER=mqm
BKUSER=mqsi
QMNAME=EAIBK1P
BKNAME=EAIBK1P
DBINST=mqsi
DBNAME=EAIBK1DB
MQEQM=GW11

MQHA_BIN=/MQHA/bin
ZETA_BIN=/mte/kerberos/ZETA/bin
TIMEOUT=30

######################################################################
# EAI 엔진 Shutdown
######################################################################

# MQ, WMQI, DB2 
echo "$QMNAME EAI Component 를 종료합니다 (WMB, WMQ, DB2 instance) in $TIMEOUT SEC."
$MQHA_BIN/hamqsi_stop_broker_as $BKNAME $QMNAME $BKUSER $DBINST $TIMEOUT 
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: $QMNAME EAI Component 종료 시 에러가 발생했습니다. 다시 하십시요"
  exit $rc
fi

exit 0
