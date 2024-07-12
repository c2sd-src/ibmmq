#!/bin/ksh
#-----------------------------------------------------------#
# Define Variables                                          #
#-----------------------------------------------------------#
export LANG=C

RUN_DATE=`date +%Y%m%d`
RUN_TIME=`date +%H%M%S`
SHELL_PATH=~mqm75/bin/utilscript
BACKUP_DIR=~mqm75/backup

#-----------------------------------------------------------#
# Check User                                                #
#-----------------------------------------------------------#
if [ `whoami` != mqm75 ]
then
  echo "Must be running as mqm75 user"
  exit 1
fi

#-----------------------------------------------------------#
# Main                                                      #
#-----------------------------------------------------------#
echo "##############################################"
echo "#        MQ Resource Backup Start            #"
echo "##############################################"

echo "                                              "
echo "----------------------------------------------"
echo ">> mq env                                    "
echo "----------------------------------------------"
${SHELL_PATH}/backup_mqenv.sh

echo "                                              "
echo "----------------------------------------------"
echo ">> mq object script                           "
echo "----------------------------------------------"
${SHELL_PATH}/backup_mqscript.sh



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
find ${BACKUP_DIR} -type f -mtime +60 -exec rm -rf {} \;


echo "                                              "
echo "##############################################"
echo "#        MQ Resource Backup End              #"
echo "##############################################"
