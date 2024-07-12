#!/bin/ksh
#Global Variable
#export LANG=en_US
MQUSER=mqm
BKUSER=mqsi
QMNAME=EAIBK1P
BKNAME=EAIBK1P
DBINST=mqsi
DBNAME=EAIBK1DB
MQEQM=GW11

MQHA_BIN=/MQHA/bin
ZETA_BIN=/mte/kerberos/ZETA/bin

######################################################################
# EAI 엔진 Start
######################################################################

# MQ, WMQI, DB2 start
echo "$QMNAME EAI Component 를 시작합니다 (WMB, WMQ, DB2 instance)"
$MQHA_BIN/hamqsi_start_broker_as $BKNAME $QMNAME $BKUSER $DBINST $DBNAME
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: $QMNAME EAI Component 시작 시 에러가 발생했습니다. 다시 하십시요"
  exit $rc
fi

# WMQ Channel start
echo "\n$QMNAME Channel 을 시작합니다"
su $MQUSER -c "$MQHA_BIN/hamqm_chl $QMNAME start"
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: WMQ Channel 시작 시 에러가 발생했습니다. 다시 하십시요"
  exit $rc
fi

# MQe Gateway start
echo "\nMQe Gateway 를 시작합니다"
su $MQUSER -c "$MQHA_BIN/hamqe_op $MQEQM start $QMNAME"
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: MQe Gateway  시작 시 에러가 발생했습니다. 다시 하십시요"
  exit $rc
fi

# MTE Control Center Agent start
echo "\nMTE Control Center Agent 를 시작합니다"
su $MQUSER -c "$MQHA_BIN/hamteagent_op start"
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: MTE Control Center Agent 시작 시 에러가 발생했습니다. 다시 하십시요"
  exit $rc
fi

# MQ Trigger Monitor Start
#echo "\n[$QMNAME] Trigger Monitor 를 시작합니다"
#su $MQUSER -c "/MQHA/bin/hamqm_trm $QMNAME start"
#rc=$?
#if [ $rc -ne 0 ]
#then
#  echo "(ERROR) ${0}: MQ Trigger Monitor 시작 시 에러가 발생했습니다. 다시 하십시요"
#  exit $rc
#fi

######################################################################
# 밴비율 관리 프로세스 Start
######################################################################

# 신용카드 밴비율 프로세스
echo "\n신용카드 밴비율 프로세스를 시작합니다"
su $BKUSER -c "/mte/msgflow/bin/startVanAutoControlManager.sh"
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: 신용카드 밴비율 프로세스 시작 시 에러가 발생했습니다. 다시 하십시요"
  exit $rc
fi

# KT 밴비율 프로세스
echo "\nKT 밴비율 프로세스를 시작합니다"
su $BKUSER -c "/mte/msgflow/bin/startVanAutoControlManagerKT.sh"
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: KT 밴비율 프로세스 시작 시 에러가 발생했습니다. 다시 하십시요"
  exit $rc
fi

# 현금영수증 밴비율 프로세스
echo "\n현금영수증 밴비율 프로세스를 시작합니다"
su $BKUSER -c "/mte/msgflow/bin/startVanAutoControlManagerCash.sh"
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: 현금영수증 밴비율 프로세스 시작 시 에러가 발생했습니다. 다시 하십시요"
  exit $rc
fi

# 신용카드 여전법 밴비율 프로세스
echo "\n신용카드 여전법 밴비율 프로세스를 종료합니다"
su $BKUSER -c "/mte/msgflow/bin/startVanAutoControlManagerCryptCredit.sh"
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: 신용카드 여전법 밴비율 프로세스 시작 시 에러가 발생했습니다. 다시 하십시요"
  exit $rc
fi
######################################################################
# ZETA 엔진 Start
######################################################################

# ZETA start
echo "\nZETA 를 시작합니다"
su $BKUSER -c "/mte/kerberos/ZETA_ONLINE/bin/startup.sh"
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: ZETA 시작 시 에러가 발생했습니다. 다시 하십시요"
  exit $rc
fi

sleep 20
clear

# ZETA_TMONEY start
#echo "\nZETA_TMONEY 를 시작합니다"
#su $BKUSER -c "/mte/kerberos/ZETA_TMONEY/bin/startup.sh"
#rc=$?
#if [ $rc -ne 0 ]
#then
#  echo "(ERROR) ${0}: ZETA_TMONEY 시작 시 에러가 발생했습니다. 다시 하십시요"
#  exit $rc
#fi

sleep 20
clear

# ZETA_DIRECT_APPV start
echo "\nZETA_DIRECT_APPV 를 시작합니다"
su $BKUSER -c "/mte/kerberos/ZETA_DIRECT_APPV/bin/startup.sh"
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: ZETA_DIRECT_APPV 시작 시 에러가 발생했습니다. 다시 하십시요"
  exit $rc
fi

sleep 20
clear

# ZETA_APPV_CASH start
echo "\nZETA_APPV_CASH 를 시작합니다"
su $BKUSER -c "/mte/kerberos/ZETA_APPV_CASH/bin/startup.sh"
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: ZETA_APPV_CASH 시작 시 에러가 발생했습니다. 다시 하십시요"
  exit $rc
fi

sleep 20
clear

# ZETA_MOBILE_APPV start
echo "\ZETA_MOBILE_APPV 를 시작합니다"
su $BKUSER -c "/mte/kerberos/ZETA_MOBILE_APPV/bin/startup.sh"
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: ZETA_MOBILE_APPV 시작 시 에러가 발생했습니다. 다시 하십시요"
  exit $rc
fi

sleep 20
clear

# ZETA_ECHO start
echo "\nZETA_ECHO 를 시작합니다"
su $BKUSER -c "/mte/kerberos/ZETA_ECHO/bin/startup.sh"
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: ZETA_ECHO 시작 시 에러가 발생했습니다. 다시 하십시요"
  exit $rc
fi


######################################################################
# SOCKET Demon Start
######################################################################

# 신용카드 직승인 승인데몬
echo "\n신용카드 직승인 승인데몬을 시작합니다"
su $MQUSER -c "/socketgw/credit_direct_appv/bin/startup.sh"
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: 신용카드 직승인 승인데몬 시작 시 에러가 발생했습니다. 다시 하십시요"
  exit $rc
fi

# 현금영수증 직승인 승인데몬
echo "\n현금영수증 직승인 승인데몬을 시작합니다"
su $MQUSER -c "/socketgw/cashbillappv/bin/startup.sh"
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: 현금영수증 직승인 승인데몬 시작 시 에러가 발생했습니다. 다시 하십시요"
  exit $rc
fi

# # 신용카드 승인데몬
echo "\n신용카드 승인데몬을 시작합니다"
su $MQUSER -c "/socketgw/creditappv/bin/startup.sh"
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: 신용카드 승인데몬 시작 시 에러가 발생했습니다. 다시 하십시요"
  exit $rc
fi

# 멤버십 승인데몬
echo "\n멤버십 승인데몬을 시작합니다"
su $MQUSER -c "/socketgw/memberappv/bin/startup.sh"
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: 멤버십 승인데몬 시작 시 에러가 발생했습니다. 다시 하십시요"
  exit $rc
fi

# 교통카드 승인데몬
echo "\n교통카드 승인데몬을 시작합니다"
su $MQUSER -c "/socketgw/tcardappv/bin/startup.sh"
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: 교통카드 승인데몬 시작 시 에러가 발생했습니다. 다시 하십시요"
  exit $rc
fi

# 현금영수증, 모바일상품권 등 기타 서비스 승인데몬
echo "\n현금영수증, 모바일상품권 등 기타 서비스 승인데몬을 시작합니다"
su $MQUSER -c "/socketgw/subappv/bin/startup.sh"
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: 현금영수증, 모바일상품권 등 기타 서비스 승인데몬 시작 시 에러가 발생했습니다. 다시 하십시요"
  exit $rc
fi

exit 0

