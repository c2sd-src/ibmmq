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

# �ſ�ī�� ���ε���
echo "\n�ſ�ī�� ���ε����� �����մϴ�"
/socketgw/creditappv/bin/shutdown.sh
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: �ſ�ī�� ���ε��� ���� �� ������ �߻��߽��ϴ�. �ٽ� �Ͻʽÿ�"
  exit $rc
fi

sleep 1

# ����� ���ε���
echo "\n����� ���ε����� �����մϴ�"
/socketgw/memberappv/bin/shutdown.sh
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: ����� ���ε��� ���� �� ������ �߻��߽��ϴ�. �ٽ� �Ͻʽÿ�"
  exit $rc
fi

sleep 1

# ����ī�� ���ε���
echo "\n����ī�� ���ε����� �����մϴ�"
/socketgw/tcardappv/bin/shutdown.sh
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: ����ī�� ���ε��� ���� �� ������ �߻��߽��ϴ�. �ٽ� �Ͻʽÿ�"
  exit $rc
fi

sleep 1

# ���ݿ�����, ����ϻ�ǰ�� �� ��Ÿ ���� ���ε���
echo "\n���ݿ�����, ����ϻ�ǰ�� �� ��Ÿ ���� ���ε����� �����մϴ�"
/socketgw/subappv/bin/shutdown.sh
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: ���ݿ�����, ����ϻ�ǰ�� �� ��Ÿ ���� ���ε��� ���� �� ������ �߻��߽��ϴ�. �ٽ� �Ͻʽÿ�"
  exit $rc
fi

sleep 1

# �ſ�ī�� ������ ���ε���
echo "\n�ſ�ī�� ������ ���ε����� �����մϴ�"
/socketgw/credit_direct_appv/bin/shutdown.sh
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: �ſ�ī�� ������ ���ε��� ���� �� ������ �߻��߽��ϴ�. �ٽ� �Ͻʽÿ�"
  exit $rc
fi

sleep 1

# ���ݿ����� ������ ���ε���
echo "\n���ݿ����� ������ ���ε����� �����մϴ�"
/socketgw/cashbillappv/bin/shutdown.sh
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: ���ݿ����� ������ ���ε��� ���� �� ������ �߻��߽��ϴ�. �ٽ� �Ͻʽÿ�"
  exit $rc
fi

sleep 1

#######################################################################
## ������ ����� ���ε��� Shutdown
######################################################################

# ������ ����� ���ε���
#echo "\n������ ����� ���ε����� �����մϴ�"
#su $BKUSER -c "/mte/kerberos/MobileAppv/bin/shutdown.sh"
#rc=$?
#if [ $rc -ne 0 ]
#then
#  echo "(ERROR) ${0}: ������ ����� ���ε��� ���� �� ������ �߻��߽��ϴ�. �ٽ� �Ͻʽÿ�"
#  exit $rc
#fi


######################################################################
# EAI ���� Shutdown
######################################################################

# MTE Control Center Agent
echo "\nMTE Control Center Agent �� �����մϴ�"
su $MQUSER -c "/MQHA/bin/hamteagent_op stop"
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: MTE Control Center Agent ���� �� ������ �߻��߽��ϴ�. �ٽ� �Ͻʽÿ�"
  exit $rc
fi

# MQe Gateway
echo "\nMQe Gateway �� �����մϴ�"
su $MQUSER -c "${MQHA_BIN}/hamqe_op ${MQEQM} stop $QMNAME"
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: MQe Gateway ���� �� ������ �߻��߽��ϴ�. �ٽ� �Ͻʽÿ�"
  exit $rc
fi

# WMQ Channel
echo "\n$QMNAME Channel �� �����մϴ�"
su $MQUSER -c "$MQHA_BIN/hamqm_chl $QMNAME stop"
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: WMQ Channel ���� �� ������ �߻��߽��ϴ�. �ٽ� �Ͻʽÿ�"
  exit $rc
fi

# MQ Trigger Monitor
#echo "\n[$QMNAME] Trigger Monitor �� �����մϴ�"
#su $MQUSER -c "/MQHA/bin/hamqm_trm $QMNAME stop"
#rc=$?
#if [ $rc -ne 0 ]
#then
#  echo "(ERROR) ${0}: MQ Trigger Monitor ���� �� ������ �߻��߽��ϴ�. �ٽ� �Ͻʽÿ�"
#  exit $rc
#fi

# MQ, WMQI, DB2 
echo "$QMNAME EAI Component �� �����մϴ� (WMB, WMQ, DB2 instance) in $TIMEOUT SEC."
#$MQHA_BIN/hamqsi_stop_broker_as $BKNAME $QMNAME $BKUSER $DBINST $TIMEOUT 
$MQHA_BIN/hamqsi_stop_broker_as $BKNAME $QMNAME $MQUSER $BKUSER $TIMEOUT
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: $QMNAME EAI Component ���� �� ������ �߻��߽��ϴ�. �ٽ� �Ͻʽÿ�"
  exit $rc
fi

######################################################################
# ZETA ���� Shutdown
######################################################################

# ZETA 
echo "\nZETA �� �����մϴ�"
su $BKUSER -c "/mte/kerberos/ZETA_ONLINE/bin/shutdown.sh"
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: ZETA ���� �� ������ �߻��߽��ϴ�. �ٽ� �Ͻʽÿ�"
  exit $rc
fi

# ZETA_TMONEY 
#echo "\nZETA_TMONEY �� �����մϴ�"
#su $BKUSER -c "/mte/kerberos/ZETA_TMONEY/bin/shutdown.sh"
#rc=$?
#if [ $rc -ne 0 ]
#then
#  echo "(ERROR) ${0}: ZETA_TMONEY ���� �� ������ �߻��߽��ϴ�. �ٽ� �Ͻʽÿ�"
#  exit $rc
#fi

# ZETA_DIRECT_APPV
echo "\nZETA_DIRECT_APPV �� �����մϴ�"
su $BKUSER -c "/mte/kerberos/ZETA_DIRECT_APPV/bin/shutdown.sh"
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: ZETA_DIRECT_APPV ���� �� ������ �߻��߽��ϴ�. �ٽ� �Ͻʽÿ�"
  exit $rc
fi

# ZETA_APPV_CASH
echo "\nZETA_APPV_CASH �� �����մϴ�"
su $BKUSER -c "/mte/kerberos/ZETA_APPV_CASH/bin/shutdown.sh"
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: ZETA_APPV_CASH ���� �� ������ �߻��߽��ϴ�. �ٽ� �Ͻʽÿ�"
  exit $rc
fi

######################################################################
# ����� ���� ���μ��� Shutdown
######################################################################

# �ſ�ī�� ����� ���μ���
echo "\n�ſ�ī�� ����� ���μ����� �����մϴ�"
su $BKUSER -c "/mte/msgflow/bin/stopVanAutoControlManager.sh"
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: �ſ�ī�� ����� ���μ��� ���� �� ������ �߻��߽��ϴ�. �ٽ� �Ͻʽÿ�"
  exit $rc
fi

# KT ����� ���μ���
echo "\nKT ����� ���μ����� �����մϴ�"
su $BKUSER -c "/mte/msgflow/bin/stopVanAutoControlManagerKT.sh"
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: KT ����� ���μ��� ���� �� ������ �߻��߽��ϴ�. �ٽ� �Ͻʽÿ�"
  exit $rc
fi

# ���ݿ����� ����� ���μ���
echo "\n���ݿ����� ����� ���μ����� �����մϴ�"
su $BKUSER -c "/mte/msgflow/bin/stopVanAutoControlManagerCash.sh"
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: ���ݿ����� ����� ���μ��� ���� �� ������ �߻��߽��ϴ�. �ٽ� �Ͻʽÿ�"
  exit $rc
fi

exit 0
