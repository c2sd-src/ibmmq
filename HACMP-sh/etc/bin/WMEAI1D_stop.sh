#!/bin/ksh
#-----------------------------------------------------------#
# Define Variable                                           #
# System 환경에 맞게 아래 변수 값을 재설정 한다.            #
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
# 여기서 부터 Components 별 구동 스크립트 작성 할것         #
#-----------------------------------------------------------#

#-----------------------------------------------------------#
# STOP_MTE_AGENT()                                          #
# Desc : MTE AGENT 정지                                     #
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
# Desc : 큐매니져 채널 정지                                 #
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
# Desc : 브로커 정지                                        #
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
# Desc : 큐매니져 정지                                      #
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
# <작성법>                                                  #
# SVC_STATUS [Skip 여부] [Function]                         #
# - [Skip 여부 : 1] -> Function Call 이 반드시 성공해야함   #
# - [Skip 여부 : 0] -> Function Call 실패시 다음 Step 진행  #
#-----------------------------------------------------------#
SVC_STATUS 0 STOP_QMGR_CHANNEL
SVC_STATUS 1 STOP_BROKER
SVC_STATUS 1 STOP_QMGR
exit 0
