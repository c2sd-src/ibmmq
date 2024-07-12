#!/bin/ksh
#Global Variable
MQUSER=mqm
BKUSER=mqsi
QMNAME=EAIBK2P
BKNAME=EAIBK2P
MQEQM=GW21

MQHA_BIN=/MQHA/bin
ZETA_BIN=/mte/kerberos/ZETA/bin
TIMEOUT=30

######################################################################
# SOCKET Demon Shutdown
######################################################################

# 신용카드 승인데몬
echo "\n신용카드 승인데몬을 종료합니다"
/socketgw/creditappv/bin/shutdown.sh
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: 신용카드 승인데몬 종료 시 에러가 발생했습니다. 다시 하십시요"
  exit $rc
fi

sleep 1

# 멤버십 승인데몬
echo "\n멤버십 승인데몬을 종료합니다"
/socketgw/memberappv/bin/shutdown.sh
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: 멤버십 승인데몬 종료 시 에러가 발생했습니다. 다시 하십시요"
  exit $rc
fi

sleep 1

# 교통카드 승인데몬
echo "\n교통카드 승인데몬을 종료합니다"
/socketgw/tcardappv/bin/shutdown.sh
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: 교통카드 승인데몬 종료 시 에러가 발생했습니다. 다시 하십시요"
  exit $rc
fi

sleep 1

# 현금영수증, 모바일상품권 등 기타 서비스 승인데몬
echo "\n현금영수증, 모바일상품권 등 기타 서비스 승인데몬을 종료합니다"
/socketgw/subappv/bin/shutdown.sh
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: 현금영수증, 모바일상품권 등 기타 서비스 승인데몬 종료 시 에러가 발생했습니다. 다시 하십시요"
  exit $rc
fi

sleep 1

# 신용카드 직승인 승인데몬
echo "\n신용카드 직승인 승인데몬을 종료합니다"
/socketgw/credit_direct_appv/bin/shutdown.sh
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: 신용카드 직승인 승인데몬 종료 시 에러가 발생했습니다. 다시 하십시요"
  exit $rc
fi

sleep 1

# 현금영수증 직승인 승인데몬
echo "\n현금영수증 직승인 승인데몬을 종료합니다"
/socketgw/cashbillappv/bin/shutdown.sh
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: 현금영수증 직승인 승인데몬 종료 시 에러가 발생했습니다. 다시 하십시요"
  exit $rc
fi

sleep 1

#######################################################################
## 나만의 냉장고 승인데몬 Shutdown
######################################################################

# 나만의 냉장고 승인데몬
#echo "\n나만의 냉장고 승인데몬을 종료합니다"
#su $BKUSER -c "/mte/kerberos/MobileAppv/bin/shutdown.sh"
#rc=$?
#if [ $rc -ne 0 ]
#then
#  echo "(ERROR) ${0}: 나만의 냉장고 승인데몬 종료 시 에러가 발생했습니다. 다시 하십시요"
#  exit $rc
#fi


######################################################################
# EAI 엔진 Shutdown
######################################################################

# MTE Control Center Agent
echo "\nMTE Control Center Agent 를 종료합니다"
su $MQUSER -c "/MQHA/bin/hamteagent_op stop"
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: MTE Control Center Agent 종료 시 에러가 발생했습니다. 다시 하십시요"
  exit $rc
fi

# MQe Gateway
echo "\nMQe Gateway 를 종료합니다"
su $MQUSER -c "${MQHA_BIN}/hamqe_op ${MQEQM} stop $QMNAME"
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: MQe Gateway 종료 시 에러가 발생했습니다. 다시 하십시요"
  exit $rc
fi

# WMQ Channel
echo "\n$QMNAME Channel 을 종료합니다"
su $MQUSER -c "$MQHA_BIN/hamqm_chl $QMNAME stop"
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: WMQ Channel 종료 시 에러가 발생했습니다. 다시 하십시요"
  exit $rc
fi

# MQ Trigger Monitor
#echo "\n[$QMNAME] Trigger Monitor 를 종료합니다"
#su $MQUSER -c "/MQHA/bin/hamqm_trm $QMNAME stop"
#rc=$?
#if [ $rc -ne 0 ]
#then
#  echo "(ERROR) ${0}: MQ Trigger Monitor 종료 시 에러가 발생했습니다. 다시 하십시요"
#  exit $rc
#fi

# MQ, WMQI, DB2 
echo "$QMNAME EAI Component 를 종료합니다 (WMB, WMQ, DB2 instance) in $TIMEOUT SEC."
#$MQHA_BIN/hamqsi_stop_broker_as $BKNAME $QMNAME $BKUSER $DBINST $TIMEOUT 
$MQHA_BIN/hamqsi_stop_broker_as $BKNAME $QMNAME $MQUSER $BKUSER $TIMEOUT
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: $QMNAME EAI Component 종료 시 에러가 발생했습니다. 다시 하십시요"
  exit $rc
fi

######################################################################
# ZETA 엔진 Shutdown
######################################################################

# ZETA 
echo "\nZETA 를 종료합니다"
su $BKUSER -c "/mte/kerberos/ZETA_ONLINE/bin/shutdown.sh"
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: ZETA 종료 시 에러가 발생했습니다. 다시 하십시요"
  exit $rc
fi

# ZETA_TMONEY 
#echo "\nZETA_TMONEY 를 종료합니다"
#su $BKUSER -c "/mte/kerberos/ZETA_TMONEY/bin/shutdown.sh"
#rc=$?
#if [ $rc -ne 0 ]
#then
#  echo "(ERROR) ${0}: ZETA_TMONEY 종료 시 에러가 발생했습니다. 다시 하십시요"
#  exit $rc
#fi

# ZETA_DIRECT_APPV
echo "\nZETA_DIRECT_APPV 를 종료합니다"
su $BKUSER -c "/mte/kerberos/ZETA_DIRECT_APPV/bin/shutdown.sh"
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: ZETA_DIRECT_APPV 종료 시 에러가 발생했습니다. 다시 하십시요"
  exit $rc
fi

# ZETA_APPV_CASH
echo "\nZETA_APPV_CASH 를 종료합니다"
su $BKUSER -c "/mte/kerberos/ZETA_APPV_CASH/bin/shutdown.sh"
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: ZETA_APPV_CASH 종료 시 에러가 발생했습니다. 다시 하십시요"
  exit $rc
fi

######################################################################
# 밴비율 관리 프로세스 Shutdown
######################################################################

# 신용카드 밴비율 프로세스
echo "\n신용카드 밴비율 프로세스를 종료합니다"
su $BKUSER -c "/mte/msgflow/bin/stopVanAutoControlManager.sh"
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: 신용카드 밴비율 프로세스 종료 시 에러가 발생했습니다. 다시 하십시요"
  exit $rc
fi

# KT 밴비율 프로세스
echo "\nKT 밴비율 프로세스를 종료합니다"
su $BKUSER -c "/mte/msgflow/bin/stopVanAutoControlManagerKT.sh"
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: KT 밴비율 프로세스 종료 시 에러가 발생했습니다. 다시 하십시요"
  exit $rc
fi

# 현금영수증 밴비율 프로세스
echo "\n현금영수증 밴비율 프로세스를 종료합니다"
su $BKUSER -c "/mte/msgflow/bin/stopVanAutoControlManagerCash.sh"
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: 현금영수증 밴비율 프로세스 종료 시 에러가 발생했습니다. 다시 하십시요"
  exit $rc
fi

exit 0
