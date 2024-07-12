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
# START_MTE_SERVER()                                        #
# Desc : MTE Server 시작                                    #
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
# Desc : MTE LOADER 시작                                    #
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
# Desc : IFM 시작                                           #
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

# <작성법>                                                  #
# SVC_STATUS [Skip 여부] [Function]                         #
# - [Skip 여부 : 1] -> Function Call 이 반드시 성공해야함   #
# - [Skip 여부 : 0] -> Function Call 실패시 다음 Step 진행  #
#-----------------------------------------------------------#
SVC_STATUS 1 START_QMGR
SVC_STATUS 0 START_MTE_SERVER
SVC_STATUS 0 START_MTE_LOADER
SVC_STATUS 0 START_MTE_IFM
exit 0
