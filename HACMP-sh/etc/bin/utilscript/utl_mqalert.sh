#!/bin/ksh
#############################################################
# script      : utl_mqalert.sh
# description : 
#  - Alter Message 를 Write 하는 용도로 사용
#  - 별도의 CheckShell Script 에서 해당 Script 를 호출한다
#############################################################
export LANG=C
SHELL_HOME=~mqm/bin/utilscript
DATE=`date +"%Y-%m-%d %H:%M:%S"`
LOGDATE=`date +"%y%m%d_%H%M%S"`
#-----------------------------------------------------------#
# 로직 구현                                                 #
#  - $1 에 호출한 Shell 정보를 전달 받아 Shell 정보에 따라  #
#    처리해야될 내용을 구현하도록 한다                      #
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
