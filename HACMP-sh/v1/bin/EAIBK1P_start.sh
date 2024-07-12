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
# EAI ���� Start
######################################################################

# MQ, WMQI, DB2 start
echo "$QMNAME EAI Component �� �����մϴ� (WMB, WMQ, DB2 instance)"
$MQHA_BIN/hamqsi_start_broker_as $BKNAME $QMNAME $BKUSER $DBINST $DBNAME
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: $QMNAME EAI Component ���� �� ������ �߻��߽��ϴ�. �ٽ� �Ͻʽÿ�"
  exit $rc
fi

# WMQ Channel start
echo "\n$QMNAME Channel �� �����մϴ�"
su $MQUSER -c "$MQHA_BIN/hamqm_chl $QMNAME start"
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: WMQ Channel ���� �� ������ �߻��߽��ϴ�. �ٽ� �Ͻʽÿ�"
  exit $rc
fi

# MQe Gateway start
echo "\nMQe Gateway �� �����մϴ�"
su $MQUSER -c "$MQHA_BIN/hamqe_op $MQEQM start $QMNAME"
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: MQe Gateway  ���� �� ������ �߻��߽��ϴ�. �ٽ� �Ͻʽÿ�"
  exit $rc
fi

# MTE Control Center Agent start
echo "\nMTE Control Center Agent �� �����մϴ�"
su $MQUSER -c "$MQHA_BIN/hamteagent_op start"
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: MTE Control Center Agent ���� �� ������ �߻��߽��ϴ�. �ٽ� �Ͻʽÿ�"
  exit $rc
fi

# MQ Trigger Monitor Start
#echo "\n[$QMNAME] Trigger Monitor �� �����մϴ�"
#su $MQUSER -c "/MQHA/bin/hamqm_trm $QMNAME start"
#rc=$?
#if [ $rc -ne 0 ]
#then
#  echo "(ERROR) ${0}: MQ Trigger Monitor ���� �� ������ �߻��߽��ϴ�. �ٽ� �Ͻʽÿ�"
#  exit $rc
#fi

######################################################################
# ����� ���� ���μ��� Start
######################################################################

# �ſ�ī�� ����� ���μ���
echo "\n�ſ�ī�� ����� ���μ����� �����մϴ�"
su $BKUSER -c "/mte/msgflow/bin/startVanAutoControlManager.sh"
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: �ſ�ī�� ����� ���μ��� ���� �� ������ �߻��߽��ϴ�. �ٽ� �Ͻʽÿ�"
  exit $rc
fi

# KT ����� ���μ���
echo "\nKT ����� ���μ����� �����մϴ�"
su $BKUSER -c "/mte/msgflow/bin/startVanAutoControlManagerKT.sh"
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: KT ����� ���μ��� ���� �� ������ �߻��߽��ϴ�. �ٽ� �Ͻʽÿ�"
  exit $rc
fi

# ���ݿ����� ����� ���μ���
echo "\n���ݿ����� ����� ���μ����� �����մϴ�"
su $BKUSER -c "/mte/msgflow/bin/startVanAutoControlManagerCash.sh"
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: ���ݿ����� ����� ���μ��� ���� �� ������ �߻��߽��ϴ�. �ٽ� �Ͻʽÿ�"
  exit $rc
fi

# �ſ�ī�� ������ ����� ���μ���
echo "\n�ſ�ī�� ������ ����� ���μ����� �����մϴ�"
su $BKUSER -c "/mte/msgflow/bin/startVanAutoControlManagerCryptCredit.sh"
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: �ſ�ī�� ������ ����� ���μ��� ���� �� ������ �߻��߽��ϴ�. �ٽ� �Ͻʽÿ�"
  exit $rc
fi
######################################################################
# ZETA ���� Start
######################################################################

# ZETA start
echo "\nZETA �� �����մϴ�"
su $BKUSER -c "/mte/kerberos/ZETA_ONLINE/bin/startup.sh"
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: ZETA ���� �� ������ �߻��߽��ϴ�. �ٽ� �Ͻʽÿ�"
  exit $rc
fi

sleep 20
clear

# ZETA_TMONEY start
#echo "\nZETA_TMONEY �� �����մϴ�"
#su $BKUSER -c "/mte/kerberos/ZETA_TMONEY/bin/startup.sh"
#rc=$?
#if [ $rc -ne 0 ]
#then
#  echo "(ERROR) ${0}: ZETA_TMONEY ���� �� ������ �߻��߽��ϴ�. �ٽ� �Ͻʽÿ�"
#  exit $rc
#fi

sleep 20
clear

# ZETA_DIRECT_APPV start
echo "\nZETA_DIRECT_APPV �� �����մϴ�"
su $BKUSER -c "/mte/kerberos/ZETA_DIRECT_APPV/bin/startup.sh"
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: ZETA_DIRECT_APPV ���� �� ������ �߻��߽��ϴ�. �ٽ� �Ͻʽÿ�"
  exit $rc
fi

sleep 20
clear

# ZETA_APPV_CASH start
echo "\nZETA_APPV_CASH �� �����մϴ�"
su $BKUSER -c "/mte/kerberos/ZETA_APPV_CASH/bin/startup.sh"
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: ZETA_APPV_CASH ���� �� ������ �߻��߽��ϴ�. �ٽ� �Ͻʽÿ�"
  exit $rc
fi

sleep 20
clear

# ZETA_MOBILE_APPV start
echo "\ZETA_MOBILE_APPV �� �����մϴ�"
su $BKUSER -c "/mte/kerberos/ZETA_MOBILE_APPV/bin/startup.sh"
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: ZETA_MOBILE_APPV ���� �� ������ �߻��߽��ϴ�. �ٽ� �Ͻʽÿ�"
  exit $rc
fi

sleep 20
clear

# ZETA_ECHO start
echo "\nZETA_ECHO �� �����մϴ�"
su $BKUSER -c "/mte/kerberos/ZETA_ECHO/bin/startup.sh"
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: ZETA_ECHO ���� �� ������ �߻��߽��ϴ�. �ٽ� �Ͻʽÿ�"
  exit $rc
fi


######################################################################
# SOCKET Demon Start
######################################################################

# �ſ�ī�� ������ ���ε���
echo "\n�ſ�ī�� ������ ���ε����� �����մϴ�"
su $MQUSER -c "/socketgw/credit_direct_appv/bin/startup.sh"
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: �ſ�ī�� ������ ���ε��� ���� �� ������ �߻��߽��ϴ�. �ٽ� �Ͻʽÿ�"
  exit $rc
fi

# ���ݿ����� ������ ���ε���
echo "\n���ݿ����� ������ ���ε����� �����մϴ�"
su $MQUSER -c "/socketgw/cashbillappv/bin/startup.sh"
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: ���ݿ����� ������ ���ε��� ���� �� ������ �߻��߽��ϴ�. �ٽ� �Ͻʽÿ�"
  exit $rc
fi

# # �ſ�ī�� ���ε���
echo "\n�ſ�ī�� ���ε����� �����մϴ�"
su $MQUSER -c "/socketgw/creditappv/bin/startup.sh"
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: �ſ�ī�� ���ε��� ���� �� ������ �߻��߽��ϴ�. �ٽ� �Ͻʽÿ�"
  exit $rc
fi

# ����� ���ε���
echo "\n����� ���ε����� �����մϴ�"
su $MQUSER -c "/socketgw/memberappv/bin/startup.sh"
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: ����� ���ε��� ���� �� ������ �߻��߽��ϴ�. �ٽ� �Ͻʽÿ�"
  exit $rc
fi

# ����ī�� ���ε���
echo "\n����ī�� ���ε����� �����մϴ�"
su $MQUSER -c "/socketgw/tcardappv/bin/startup.sh"
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: ����ī�� ���ε��� ���� �� ������ �߻��߽��ϴ�. �ٽ� �Ͻʽÿ�"
  exit $rc
fi

# ���ݿ�����, ����ϻ�ǰ�� �� ��Ÿ ���� ���ε���
echo "\n���ݿ�����, ����ϻ�ǰ�� �� ��Ÿ ���� ���ε����� �����մϴ�"
su $MQUSER -c "/socketgw/subappv/bin/startup.sh"
rc=$?
if [ $rc -ne 0 ]
then
  echo "(ERROR) ${0}: ���ݿ�����, ����ϻ�ǰ�� �� ��Ÿ ���� ���ε��� ���� �� ������ �߻��߽��ϴ�. �ٽ� �Ͻʽÿ�"
  exit $rc
fi

exit 0

