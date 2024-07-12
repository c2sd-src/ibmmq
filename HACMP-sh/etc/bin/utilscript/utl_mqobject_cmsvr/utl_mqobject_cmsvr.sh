#!/bin/ksh
export LANG=C
#################################################################
# script      : utl_mqobject_cmsvr.sh
# description : 
#  - ��ż��� �ű�/���� ���� ������ �����Ͽ� MQ Object ����/����
#  - ���� ���Ǽ��� ���� util ������ �����ϴ� Script �̹Ƿ�
#    EAI Admin �� �ݵ�� ������ Ȯ�� ������ �����ϵ��� �Ѵ�
#  - crontab schedule : ���� 23��
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
# 2) ����� ���� ����                                       #
# 3) output ���丮�� backup                               #
# 4) ������ output ���� ���� ( 30�� ���� )                  #
#-----------------------------------------------------------#
ksh ${SCRIPT_HOME}/ctl_dbselect.sh "${SCRIPT_HOME}/ctl_dbselect.out"
ksh ${SCRIPT_HOME}/ctl_dbselect.out
sleep 10
mv ${SCRIPT_HOME}/ctl_dbselect.out ${SCRIPT_HOME}/output/ctl_dbselect.out_${DATE}
find ${SCRIPT_HOME}/output -type f -mtime +30 -exec rm -rf {} \;