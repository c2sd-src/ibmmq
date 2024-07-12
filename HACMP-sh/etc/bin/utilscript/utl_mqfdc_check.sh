#!/bin/ksh
#############################################################
# script      : utl_mqfdc_check.sh
# description : 
#  - FDC �߻��� Pattern �� �˻��Ͽ� Alter message �� �߻���Ű
#    �� �뵵�� ���ȴ�
#  - Pattern �� �Ʒ� SEARCH_PATTERN �� �����Ѵ�
#  - ���� ������ ������ MQ Process �� ������ �����ϰ�� ����
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
