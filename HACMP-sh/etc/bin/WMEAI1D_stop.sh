#!/bin/ksh
#-----------------------------------------------------------#
# Define Variable                                           #
# System ȯ�濡 �°� �Ʒ� ���� ���� �缳�� �Ѵ�.            #
#-----------------------------------------------------------#
MQUSER=mqm75
BKUSER=mqsi80
QMNAME=WMEAI1D
BKNAME=WMEAI1DBK

export HASCRIPT_DIR=~mqm75
export HASCRIPT_BIN=${HASCRIPT_DIR}/bin
export DATA_DIR=/eai1/data

TIMEOUT=20

#-----------------------------------------------------------#
# common script import                                      #
#-----------------------------------------------------------#
. ${HASCRIPT_BIN}/.common




#-----------------------------------------------------------#
# ���⼭ ���� Components �� ���� ��ũ��Ʈ �ۼ� �Ұ�         #
#-----------------------------------------------------------#

#-----------------------------------------------------------#
# STOP_MTE_AGENT()                                          #
# Desc : MTE AGENT ����                                     #
#-----------------------------------------------------------#
STOP_MTE_AGENT()
{
  echo "----------------------------------------------------"
  echo ">> MTE Control Center Agent Stop                    "
  echo ">> switch user : $MQUSER                            "
  echo "----------------------------------------------------"
  su - wmeai -c "cd ${DATA_DIR}/mte/GSWM/mteagent; agent stop"
  return $?
}


#-----------------------------------------------------------#
# STOP_QMGR_CHANNEL()                                       #
# Desc : ť�Ŵ��� ä�� ����                                 #
#-----------------------------------------------------------#
STOP_QMGR_CHANNEL()
{
  echo "----------------------------------------------------"
  echo ">> QManager Channel Stop ($QMNAME)                  "
  echo ">> switch user : $MQUSER                            "
  echo "----------------------------------------------------"
  su - $MQUSER -c "${HASCRIPT_BIN}/subscript/mqch_op $QMNAME stopALL"
  return $?
}

#-----------------------------------------------------------#
# STOP_BROKER()                                             #
# Desc : ���Ŀ ����                                        #
#-----------------------------------------------------------#
STOP_BROKER()
{
  echo "----------------------------------------------------"
  echo ">> Broker Stop ($BKNAME) - TIMEOUT($TIMEOUT SEC.)   "
  echo ">> switch user : $BKUSER                            "
  echo "----------------------------------------------------"
  su - $BKUSER -c "${HASCRIPT_BIN}/subscript/hamqsi_stop_broker $BKNAME $TIMEOUT"
  return $?
}

#-----------------------------------------------------------#
# STOP_QMGR()                                               #
# Desc : ť�Ŵ��� ����                                      #
#-----------------------------------------------------------#
STOP_QMGR()
{
  echo "----------------------------------------------------"
  echo ">> QManager Stop ($QMNAME) - TIMEOUT($TIMEOUT SEC.) "
  echo ">> switch user : $MQUSER                            "
  echo "----------------------------------------------------"
  su - $MQUSER -c "${HASCRIPT_DIR}/bin/subscript/hamqm_stop_qm $QMNAME $TIMEOUT"
  return $?
}


#-----------------------------------------------------------#
# Script Function Call                                      #
# <�ۼ���>                                                  #
# SVC_STATUS [Skip ����] [Function]                         #
# - [Skip ���� : 1] -> Function Call �� �ݵ�� �����ؾ���   #
# - [Skip ���� : 0] -> Function Call ���н� ���� Step ����  #
#-----------------------------------------------------------#
SVC_STATUS 0 STOP_QMGR_CHANNEL
SVC_STATUS 1 STOP_BROKER
SVC_STATUS 1 STOP_QMGR
exit 0
