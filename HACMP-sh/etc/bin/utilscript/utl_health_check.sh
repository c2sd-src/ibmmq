#!/bin/ksh
#############################################################
# script      : utl_health_check.sh
# description : 
#  - health_check 대상 스크립트를 등록한다
#############################################################

export LANG=C
SHELL_HOME=~mqm75/bin/utilscript
#-----------------------------------------------------------#
# Health Check Script List                                  #
#-----------------------------------------------------------#
${SHELL_HOME}/utl_mqfdc_check.sh

exit 0
