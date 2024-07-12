#!/bin/ksh
#############################################################
# script      : utl_mqfdc_check.sh
# description : 
#  - FDC 발생시 Pattern 을 검색하여 Alter message 를 발생시키
#    는 용도로 사용된다
#  - Pattern 은 아래 SEARCH_PATTERN 에 설정한다
#  - 현재 설정된 내용은 MQ Process 의 비정상 종료일경우 감지
#############################################################

export LANG=C
SHELL_HOME=~mqm/bin/utilscript
DATE=`date +"%Y-%m-%d %H:%M:%S"`
LOGDATE=`date +"%y%m%d_%H%M%S"`
#-----------------------------------------------------------#
# FDC Pattern Check                                         #
#-----------------------------------------------------------#
INTERVAL=5
SEARCH_PATTERN="ZX005025|ZX005030|zrcX_PROCESS_MISSING"
SEARCH_PATH="/var/mqm/errors/*.FDC"
START_COMMAND="${SHELL_HOME}/utl_mqalert.sh utl_mqfdc_check"

CHK_SHELL=`ps -ef | grep mqm75 | grep trapit.sh | egrep "${SEARCH_PATTERN}|${START_COMMAND}" | egrep -v "grep" | awk '{print $2}'`
if [ -z "${CHK_SHELL}" ]
then
	echo "----------------------------------------------------"
	echo ">> mq fdc check script start"
	echo "----------------------------------------------------"
	rm -f ${SHELL_HOME}/.trapit.* 2>/dev/null
	${SHELL_HOME}/trapit.sh -e "${SEARCH_PATTERN}" -i ${INTERVAL} -f "${SEARCH_PATH}" -t "${START_COMMAND}" &
else
	echo "----------------------------------------------------"
	echo ">> mq fdc check script already running"
	echo "----------------------------------------------------"
fi

exit 0
