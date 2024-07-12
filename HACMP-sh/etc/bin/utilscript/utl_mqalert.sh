#!/bin/ksh
#############################################################
# script      : utl_mqalert.sh
# description : 
#  - Alter Message �� Write �ϴ� �뵵�� ���
#  - ������ CheckShell Script ���� �ش� Script �� ȣ���Ѵ�
#############################################################
export LANG=C
SHELL_HOME=~mqm/bin/utilscript
DATE=`date +"%Y-%m-%d %H:%M:%S"`
LOGDATE=`date +"%y%m%d_%H%M%S"`
#-----------------------------------------------------------#
# ���� ����                                                 #
#  - $1 �� ȣ���� Shell ������ ���� �޾� Shell ������ ����  #
#    ó���ؾߵ� ������ �����ϵ��� �Ѵ�                      #
#-----------------------------------------------------------#
if [ "$1" = "utl_mqfdc_check" ]
then
	echo "[$DATE] `hostname` - MQ Process Unexpected Ended (/var/mqm/errors/fdc_${LOGDATE}.tar check please)" >> /var/mqm/errors/mqhealth_check.log
	cd /var/mqm/errors
	tar cvf fdc_${LOGDATE}.tar *.FDC *.LOG
	rm -f *.FDC	
else
	echo "Alert Message N/A"
fi

exit 0
