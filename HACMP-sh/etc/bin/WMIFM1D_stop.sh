#!/bin/ksh
#-----------------------------------------------------------#
# Define Variable                                           #
# System ȯ�濡 �°� �Ʒ� ���� ���� �缳�� �Ѵ�.            #
#-----------------------------------------------------------#
MQUSER=mqm75
QMNAME=WMIFM1D

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
# STOP_MTE_IFM()                                            #
# Desc : MTE IFM ����                                       #
#-----------------------------------------------------------#
STOP_MTE_IFM()
{
 echo "----------------------------------------------------"
 echo ">> MTE IFM-Tomcat Stop                              "
 echo ">> switch user : $MQUSER                            "
 echo "----------------------------------------------------"
 su - wmeai -c "${DATA_DIR}/mte/GSWM/ifm/tomcat/bin/ifm.sh stop"
 return $?
}

#-----------------------------------------------------------#
# STOP_MTE_LOADER()                                         #
# Desc : MTE LOADER ����                                    #
#-----------------------------------------------------------#
STOP_MTE_LOADER()
{
 echo "----------------------------------------------------"
 echo ">> MTE Loader Stop                                  "
 echo ">> switch user : $MQUSER                            "
 echo "----------------------------------------------------"
 su - wmeai -c "cd ${DATA_DIR}/mte/GSWM/ifm/loader/bin; ./loader.sh stop"
 return $?
}



#-----------------------------------------------------------#
# STOP_MTE_SERVER()                                         #
# Desc : MTE SERVER ����                                    #
#-----------------------------------------------------------#
STOP_MTE_SERVER()
{
 echo "----------------------------------------------------"
 echo ">> MTE Control Center Server Stop                   "
 echo ">> switch user : $MQUSER                            "
 echo "----------------------------------------------------"
 su - wmeai -c "cd ${DATA_DIR}/mte/GSWM/mteserver; ./server stop" 
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
SVC_STATUS 0 STOP_MTE_IFM
SVC_STATUS 0 STOP_MTE_LOADER
SVC_STATUS 0 STOP_MTE_SERVER
SVC_STATUS 1 STOP_QMGR
exit 0
