#!/bin/ksh
#-----------------------------------------------------------#
# Define Variables                                          #
#-----------------------------------------------------------#
export LANG=C

RUN_DATE=`date +%Y%m%d`
RUN_TIME=`date +%H%M%S`
SAVEQMGR_PATH=~mqm/bin/utilscript/saveqmgr
SAVEQMGR_CMD=${SAVEQMGR_PATH}/saveqmgr
BACKUP_DIR=~mqm/backup/$RUN_DATE/mqscript


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
# SAVEQMGR_CMD                                              #
#-----------------------------------------------------------#
case `uname -s` in
	AIX) 
		SAVEQMGR_CMD=${SAVEQMGR_PATH}/saveqmgr.aix
	;;
	SunOS)
		SAVEQMGR_CMD=${SAVEQMGR_PATH}/saveqmgr.solaris
	;;
	HP-UX)
		IS_IA64=`uname -a | grep ia64`
		if [ -z "${IS_IA64}" ]
		then
			SAVEQMGR_CMD=${SAVEQMGR_PATH}/saveqmgr.hp	  
		else
			SAVEQMGR_CMD=${SAVEQMGR_PATH}/saveqmgr.hpia64
		fi
	;;
esac

echo "SAVEQMGR_CMD = [${SAVEQMGR_CMD}]"

#-----------------------------------------------------------#
# SAVEQMGR RUN                                              #
#-----------------------------------------------------------#
QMGRS=`dspmq | grep -i running | awk -F"(" '{print $2}' | awk -F")" '{print $1}'`
for QM in $QMGRS
do
	${SAVEQMGR_CMD} -m $QM -o -f ${BACKUP_DIR}/${QM}_${RUN_DATE}.mqs
done;