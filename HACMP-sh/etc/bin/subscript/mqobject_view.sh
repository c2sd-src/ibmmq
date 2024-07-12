#!/bin/ksh
export LANG=C
DATE=`date +%Y-%m-%d`

QMANAGER="CCSID DEADQ MAXMSGL"
QREMOTE="TYPE DEFPSIST RQMNAME RNAME XMITQ"
QLOCAL="TYPE MAXMSGL MAXDEPTH DEFPSIST CLUSTER DEFBIND"
CHANNEL_SDR="CHLTYPE MAXMSGL DISCINT CONNAME XMITQ"
CHANNEL_RCVR="CHLTYPE MAXMSGL"
CHANNEL_CLUSSDR="CHLTYPE MAXMSGL DISCINT CONNAME"
CHANNEL_CLUSRCVR="CHLTYPE MAXMSGL DISCINT"
CHANNEL_SVRCONN="CHLTYPE MAXMSGL MCAUSER"
LISTENER="CONTROL"

SYSTEM_ADD=NO

save_obj()
{
  OBJ="$1"
  KEY="$2"
  DIS="$3"
  TITLE="$4"
  QMGR="$5"
  FILE=cts_`hostname`_$QMGR.txt
  
  OBJ_GREP=`echo ${OBJ} | sed -e "s/ /|/g"`
  if [ "${KEY}" = "CHANNEL" ]
  then
    OBJ_ATTR=`echo ${OBJ} | sed -e "s/CHLTYPE/CHLTYPE(${TITLE})/g"`
    OBJ_LIST=`echo "dis ${DIS}(*) ${OBJ_ATTR}" | runmqsc ${QMGR} | grep -v dis | egrep "${KEY}|${OBJ_GREP}" | sed -e "s/( )/()/g"`
  elif [ "${KEY}" = "QMNAME" ]
  then
    OBJ_LIST=`echo "dis ${DIS} ${OBJ}" | runmqsc ${QMGR} | grep -v dis | egrep "${KEY}|${OBJ_GREP}" | sed -e "s/( )/()/g"`
  else
    OBJ_LIST=`echo "dis ${DIS}(*) ${OBJ}" | runmqsc ${QMGR} | grep -v dis | egrep "${KEY}|${OBJ_GREP}" | sed -e "s/( )/()/g"`
  fi
  
  FIELD_CNT=`echo "$OBJ_GREP" | awk -F"|" '{print NF}'`
  FIELD_CNT=`expr $FIELD_CNT + 1`
  
  idx=0  


  echo "****${TITLE}****" >> ${FILE}
  
  for OBJ_ATTR in ${OBJ_LIST}
  do
  
	 idx=`expr $idx + 1`
	 
   CHK_FIELD=`echo ${OBJ_ATTR} | cut -d"(" -f 1`

   if [ "${CHK_FIELD}" = "${KEY}" ]
   then
     PRINT_STR="${OBJ_ATTR}"
   else
     
     if [ "${CHK_FIELD}" = "CONNAME" ]
     then
        OBJ_ATTR=`echo ${OBJ_ATTR} | sed -e "s/CONNAME(/CONNAME('/g" | sed -e "s/)\$/')/g"`
     fi
     
     PRINT_STR="${PRINT_STR} ${OBJ_ATTR}"

   fi
   
   if [ idx -eq FIELD_CNT ]
   then
      if [ "${SYSTEM_ADD}" = "NO" ]
      then
        echo $PRINT_STR | grep -v "SYSTEM." >> ${FILE}
      else
        echo $PRINT_STR >> ${FILE}
      fi
      
      idx=0

   fi
   
  done

}

#OBJ KEY DIS TITLE QMGRNAME
QMName=`dspmq  | grep Running | awk -F"(" '{print $2}' | awk -F")" '{print $1}'`
for QM in $QMName
do
	echo "###########################################"
	echo "#   MQ Object Script Check-$QM            #"
	echo "###########################################"

	save_obj "$QMANAGER" "QMNAME" "qmgr" "QMANAGER" "$QM"
	save_obj "$QREMOTE" "QUEUE" "qr" "QREMOTE" "$QM"
	save_obj "$QLOCAL" "QUEUE" "ql" "QLOCAL" "$QM"
	save_obj "$CHANNEL_SDR" "CHANNEL" "chl" "SDR" "$QM"
	save_obj "$CHANNEL_RCVR" "CHANNEL" "chl" "RCVR" "$QM"
	save_obj "$CHANNEL_SVRCONN" "CHANNEL" "chl" "SVRCONN" "$QM"
	save_obj "$CHANNEL_CLUSSDR" "CHANNEL" "chl" "CLUSSDR" "$QM"
	save_obj "$CHANNEL_CLUSRCVR" "CHANNEL" "chl" "CLUSRCVR" "$QM"
	save_obj "$LISTENER" "LISTENER" "listener" "LISTENER" "$QM"
done;
