#!/bin/ksh
#-----------------------------------------------------------#
# Define Variable                                           #
# System ȯ�濡 �°� �Ʒ� ���� ���� �缳�� �Ѵ�.            #
#-----------------------------------------------------------#
MQUSER=mqm75
BKUSER=mqsi80
QMNAME=WMEAI2D
BKNAME=WMEAI2DBK

export HASCRIPT_DIR=~mqm75
export HASCRIPT_BIN=${HASCRIPT_DIR}/bin
export DATA_DIR=/eai2/data

#-----------------------------------------------------------#
# common script import                                      #
#-----------------------------------------------------------#
. ${HASCRIPT_BIN}/.common




#-----------------------------------------------------------#
# ���⼭ ���� Components �� ���� ��ũ��Ʈ �ۼ� �Ұ�         #
#-----------------------------------------------------------#

#-----------------------------------------------------------#
# START_QMGR()                                              #
# Desc : ť�Ŵ��� ����                                      #
#-----------------------------------------------------------#
START_QMGR()
{
  echo "----------------------------------------------------"
  echo ">> QManager Start ($QMNAME)                         "
  echo ">> switch user : $MQUSER                            "
  echo "----------------------------------------------------"

  su - $MQUSER -c "${HASCRIPT_BIN}/subscript/hamqm_start_qm $QMNAME"
  return $? 
}

#-----------------------------------------------------------#
# START_BROKER()                                            #
# Desc : ���Ŀ ����                                        #
#-----------------------------------------------------------#
START_BROKER()
{
  echo "----------------------------------------------------"
  echo ">> Broker Start ($BKNAME)                           "
  echo ">> switch user : $BKUSER                            "
  echo "----------------------------------------------------"

  su - $BKUSER -c "${HASCRIPT_BIN}/subscript/hamqsi_start_broker $BKNAME"
  return $?
}

#-----------------------------------------------------------#
# START_QMGR_CHANNEL()                                      #
# Desc : ť�Ŵ��� ä�� ����                                 #
#-----------------------------------------------------------#
START_QMGR_CHANNEL()
{
  echo "----------------------------------------------------"
  echo ">> QManager Channel Start ($QMNAME)                 "
  echo ">> switch user : $MQUSER                            "
  echo "----------------------------------------------------"

  su - $MQUSER -c "${HASCRIPT_BIN}/subscript/mqch_op $QMNAME startALL"
  return $?
}

#-----------------------------------------------------------#
# START_MTE_AGENT()                                         #
# Desc : MTE Agent ����                                     #
#-----------------------------------------------------------#
START_MTE_AGENT()
{
  echo "----------------------------------------------------"
  echo ">> MTE Control Center Agent Start ($QMNAME)         "
  echo ">> switch user :  wmeai                             "
  echo "----------------------------------------------------"
  
  su - wmeai -c "cd ${DATA_DIR}/mte/GSWM/mteagent; agent start"
  return $?
}


#-----------------------------------------------------------#
# Script Function Call                                      #
# <�ۼ���>                                                  #
# SVC_STATUS [Skip ����] [Function]                         #
# - [Skip ���� : 1] -> Function Call �� �ݵ�� �����ؾ���   #
# - [Skip ���� : 0] -> Function Call ���н� ���� Step ����  #
#-----------------------------------------------------------#
SVC_STATUS 1 START_QMGR
SVC_STATUS 1 START_BROKER
SVC_STATUS 0 START_QMGR_CHANNEL
SVC_STATUS 0 START_MTE_AGENT
exit 0
