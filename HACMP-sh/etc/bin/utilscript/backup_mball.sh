#!/bin/ksh
#-----------------------------------------------------------#
# Define Variables                                          #
#-----------------------------------------------------------#
export LANG=C

RUN_DATE=`date +%Y%m%d`
RUN_TIME=`date +%H%M%S`
SHELL_PATH=~mqm75/bin/utilscript
BACKUP_DIR=~mqsi80/backup

#-----------------------------------------------------------#
# Check User                                                #
#-----------------------------------------------------------#
if [ `whoami` != mqsi80 ]
then
  echo "Must be running as mqsi80 user"
  exit 1
fi

echo "##############################################"
echo "#         MB Resource Backup Start           #"
echo "##############################################"

echo "                                              "
echo "----------------------------------------------"
echo ">> mb env                                    "
echo "----------------------------------------------"
${SHELL_PATH}/backup_mbenv.sh

echo "                                              "
echo "----------------------------------------------"
echo ">> mb broker                                  "
echo "----------------------------------------------"
${SHELL_PATH}/backup_mbbroker.sh



echo "                                              "
echo "----------------------------------------------"
echo ">> tar cvf                                    "
echo "----------------------------------------------"
cd $BACKUP_DIR
DIRs=`ls $BACKUP_DIR`
for DIR in $DIRs
do
	if [ -d $DIR ]
	then
		if [ $DIR -lt $RUN_DATE ]
		then
			tar -cvf ${BACKUP_DIR}/${DIR}.tar ${DIR}
			rm -rf ${DIR}
		fi
	fi	
done
find ${BACKUP_DIR} -type f -mtime +90 -exec rm -rf {} \;

echo "                                              "
echo "##############################################"
echo "#         MB Resource Backup End             #"
echo "##############################################"
