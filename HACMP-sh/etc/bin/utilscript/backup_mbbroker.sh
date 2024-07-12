#!/bin/ksh
#-----------------------------------------------------------#
# Define Variables                                          #
#-----------------------------------------------------------#
export LANG=C

RUN_DATE=`date +%Y%m%d`
RUN_TIME=`date +%H%M%S`
BACKUP_DIR=~mqsi/backup/$RUN_DATE/broker

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
# Backup Broker                                             #
#-----------------------------------------------------------#

BROKERS=`mqsilist -d 0 | grep Broker | awk -F": " '{print $3}' | awk -F"  -  " '{print $1}'`
for BROKER in $BROKERS
do
	mqsibackupbroker ${BROKER} -d ${BACKUP_DIR}
done;



