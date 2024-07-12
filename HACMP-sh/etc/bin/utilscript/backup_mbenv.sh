#!/bin/ksh
#-----------------------------------------------------------#
# Define Variables                                          #
#-----------------------------------------------------------#
export LANG=C

RUN_DATE=`date +%Y%m%d`
RUN_TIME=`date +%H%M%S`
SHELL_PATH=~mqm/bin/utilscript
BACKUP_DIR=~mqsi/backup/$RUN_DATE/eaienv

#-----------------------------------------------------------#
# Check User                                                #
#-----------------------------------------------------------#
if [ `whoami` != mqsi ]
then
  echo "Must be running as mqsi user"
  exit 1
fi

#-----------------------------------------------------------#
# Make Directory                                            #
#-----------------------------------------------------------#
umask 002
DIR_CHK=`ls -al ${BACKUP_DIR} 2>/dev/null`
if [ -z "$DIR_CHK" ]
then
	echo "Directory Not Found(${BACKUP_DIR})"
	echo "mkdir -p ${BACKUP_DIR}"
	mkdir -p ${BACKUP_DIR}
fi


#-----------------------------------------------------------#
# mqsi .profile                                             #
#-----------------------------------------------------------#
cp ~mqsi/.profile ${BACKUP_DIR}/mqsi.profile_${RUN_DATE}

#-----------------------------------------------------------#
# gssm log4j                                                #
#-----------------------------------------------------------#
cp /var/mqsi/gssm/conf/common.xml ${BACKUP_DIR}/gssm_common.xml_${RUN_DATE}
cp /var/mqsi/gssm/conf/log4j.xml ${BACKUP_DIR}/gssm_log4j.xml_${RUN_DATE}

#-----------------------------------------------------------#
# odbc.ini                                                  #
#-----------------------------------------------------------#
cp /var/mqsi/odbc/odbc.ini ${BACKUP_DIR}/odbc.ini_${RUN_DATE}