#!/bin/ksh
export LANG=C
#################################################################
# script      : utl_mqobject_cmsvr.sh
# description : 
#  - 통신서버 신규/폐점 점보 정보를 추출하여 MQ Object 생성/삭제
#  - 관리 편의성을 위해 util 성으로 제공하는 Script 이므로
#    EAI Admin 은 반드시 별도의 확인 절차를 수행하도록 한다
#  - crontab schedule : 매일 23시
#################################################################

#-----------------------------------------------------------#
# Define Variable                                           #
#                                                           #
#-----------------------------------------------------------#
SCRIPT_HOME=~mqm/bin/utilscript/utl_mqobject_cmsvr
DATE=`date +"%y%m%d_%H%M%S"`

#-----------------------------------------------------------#
# Make output Directory                                     #
#-----------------------------------------------------------#
umask 022
DIR_CHK=`ls -al ${SCRIPT_HOME}/output 2>/dev/null`
if [ -z "$DIR_CHK" ]
then
	echo "Directory Not Found(${SCRIPT_HOME}/output)"
	echo "mkdir -p ${SCRIPT_HOME}/output"
	mkdir -p ${SCRIPT_HOME}/output
fi

#-----------------------------------------------------------#
# Main                                                      #
# 1) db select                                              #
# 2) 추출된 정보 실행                                       #
# 3) output 디렉토리에 backup                               #
# 4) 오래된 output 파일 삭제 ( 30일 보관 )                  #
#-----------------------------------------------------------#
ksh ${SCRIPT_HOME}/ctl_dbselect.sh "${SCRIPT_HOME}/ctl_dbselect.out"
ksh ${SCRIPT_HOME}/ctl_dbselect.out
sleep 10
mv ${SCRIPT_HOME}/ctl_dbselect.out ${SCRIPT_HOME}/output/ctl_dbselect.out_${DATE}
find ${SCRIPT_HOME}/output -type f -mtime +30 -exec rm -rf {} \;