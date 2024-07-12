#!/bin/ksh
#-----------------------------------------------------------#
# Define Variable                                           #
# System 환경에 맞게 아래 변수 값을 재설정 한다.            #
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
# 여기서 부터 Components 별 구동 스크립트 작성 할것         #
#-----------------------------------------------------------#

#-----------------------------------------------------------#
# START_QMGR()                                              #
# Desc : 큐매니져 시작                                      #
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
# Desc : 브로커 시작                                        #
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
# Desc : 큐매니져 채널 시작                                 #
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
# Desc : MTE Agent 시작                                     #
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
# <작성법>                                                  #
# SVC_STATUS [Skip 여부] [Function]                         #
# - [Skip 여부 : 1] -> Function Call 이 반드시 성공해야함   #
# - [Skip 여부 : 0] -> Function Call 실패시 다음 Step 진행  #
#-----------------------------------------------------------#
SVC_STATUS 1 START_QMGR
SVC_STATUS 1 START_BROKER
SVC_STATUS 0 START_QMGR_CHANNEL
SVC_STATUS 0 START_MTE_AGENT
exit 0
