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
# START_MTE_SERVER()                                        #
# Desc : MTE Server ����                                    #
#-----------------------------------------------------------#
START_MTE_SERVER()
{
  echo "----------------------------------------------------"
  echo ">> MTE Control Center Server Start                  "
  echo ">> switch user : wmeai                              "
  echo "----------------------------------------------------"
  su - wmeai -c "cd ${DATA_DIR}/mte/GSWM/mteserver; ./server start"
  return $?
}

#-----------------------------------------------------------#
# START_MTE_LOADER()                                        #
# Desc : MTE LOADER ����                                    #
#-----------------------------------------------------------#
START_MTE_LOADER()
{
  echo "----------------------------------------------------"
  echo ">> MTE Loader Start                                 "
  echo ">> switch user : wmeai                              "
  echo "----------------------------------------------------"
  su - wmeai -c "cd ${DATA_DIR}/mte/GSWM/ifm/loader/bin; ./loader.sh start"
  return $?
}  

#-----------------------------------------------------------#
# START_MTE_IFM()                                           #
# Desc : IFM ����                                           #
#-----------------------------------------------------------#
START_MTE_IFM()
{
  echo "----------------------------------------------------"
  echo ">> MTE IFM-Tomcat Start                             "
  echo ">> switch user : wmeai                              "
  echo "----------------------------------------------------"
  su - wmeai -c "${DATA_DIR}/mte/GSWM/ifm/tomcat/bin/ifm.sh start"                      
  return $?
}

# <�ۼ���>                                                  #
# SVC_STATUS [Skip ����] [Function]                         #
# - [Skip ���� : 1] -> Function Call �� �ݵ�� �����ؾ���   #
# - [Skip ���� : 0] -> Function Call ���н� ���� Step ����  #
#-----------------------------------------------------------#
SVC_STATUS 1 START_QMGR
SVC_STATUS 0 START_MTE_SERVER
SVC_STATUS 0 START_MTE_LOADER
SVC_STATUS 0 START_MTE_IFM
exit 0
