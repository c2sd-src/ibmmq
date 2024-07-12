#!/bin/ksh
#-----------------------------------------------------------#
# Define Variable                                           #
# System 환경에 맞게 아래 변수 값을 재설정 한다.            #
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
# 여기서 부터 Components 별 구동 스크립트 작성 할것         #
#-----------------------------------------------------------#

#-----------------------------------------------------------#
# STOP_MTE_IFM()                                            #
# Desc : MTE IFM 정지                                       #
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
# Desc : MTE LOADER 정지                                    #
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
# Desc : MTE SERVER 정지                                    #
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
SVC_STATUS 0 STOP_MTE_IFM
SVC_STATUS 0 STOP_MTE_LOADER
SVC_STATUS 0 STOP_MTE_SERVER
SVC_STATUS 1 STOP_QMGR
exit 0
