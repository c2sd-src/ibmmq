#!/bin/ksh
#-----------------------------------------------------------#
# Define Variables                                          #
#-----------------------------------------------------------#
export LANG=C

RUN_DATE=`date +%Y%m%d`
RUN_TIME=`date +%H%M%S`
SHELL_PATH=~mqm/bin/utilscript
BACKUP_DIR=~mqm/backup/$RUN_DATE/eaienv

#-----------------------------------------------------------#
# Check User                                                #
#-----------------------------------------------------------#
if [ `whoami` != mqm ]
then
  echo "Must be running as mqm user"
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
# mqm .profile                                              #
#-----------------------------------------------------------#
cp ~mqm/.profile ${BACKUP_DIR}/mqm.profile_${RUN_DATE}

#-----------------------------------------------------------#
# mqs.ini / qm.ini                                          #
#-----------------------------------------------------------#
cp /var/mqm/mqs.ini ${BACKUP_DIR}/mqs.ini_${RUN_DATE}

QMGRS=`dspmq | awk -F"(" '{print $2}' | awk -F")" '{print $1}'`
for QM in $QMGRS
do
	cp `${SHELL_PATH}/qmpath.sh ${QM}`/qm.ini ${BACKUP_DIR}/${QM}.qm.ini_${RUN_DATE} 2>/dev/null
done;

#-----------------------------------------------------------#
# .mte_profile                                              #
#-----------------------------------------------------------#
cp /eai1/data/mte/.mte_profile ${BACKUP_DIR}/.mte_profile_${RUN_DATE}