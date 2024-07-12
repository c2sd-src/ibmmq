#!/usr/bin/ksh
export LANG=C
#################################################################
# script      : ctl_mqobject.sh
# description : 
#  - 추출된 통신서버 신규/폐점 점보 정보로 MQ Object 생성/삭제
#################################################################

#-----------------------------------------------------------#
# Define Variable                                           #
#                                                           #
#-----------------------------------------------------------#
MQSC_PATH=~mqm/bin/subscript
SCRIPT_HOME=~mqm/bin/utilscript/utl_mqobject_cmsvr
. ${SCRIPT_HOME}/.server_info

# MQCCSID Information
export MQCCSID=1208

# Object Attribute Value
MAXMSGL=104857600
DISCINT=0
HBINT=10
SHORTRTY=120
SHORTTMR=20
BATCHSZ=20
COMPMSG=ZLIBFAST

DEFPSIST=YES
MAXDEPTH=999999999

# Interface Process Type(Batch or Non-Batch) + Seq
INTF_PROCESS_TYPE="N1 B1"

#-----------------------------------------------------------#
# syntax()                                                  #
#-----------------------------------------------------------#
syntax()
{
	echo "#-----------------------------------------------------------#"
	echo "Usage: $0 <STR_CD> <IP Address> <CMD>"
	echo "       <CMD> Options : I|D"
	echo "       - I : MQ Object define"
	echo "       - D : MQ Object delete"
	echo "#-----------------------------------------------------------#"
	exit 1
}

#-----------------------------------------------------------#
# DEFINE SDR CHANNEL                                        #
# - HUB02에 생성한다.                                       #
# - Batch/Non-Batch 용 2개의 채널을 생성함                  #
#-----------------------------------------------------------#
def_sdr_chl()
{
	for TYPE in ${INTF_PROCESS_TYPE}
	do
		OBJ_NAME="${HUB02_QM}.CM${STR_CD}.${TYPE}"
	
		DEF_STR=""
		DEF_STR=`echo ${DEF_STR} "DEF CHL(${OBJ_NAME}) CHLTYPE(SDR)"`
		DEF_STR=`echo ${DEF_STR} " CONNAME('${SVR_IP}(1414)')"`
		DEF_STR=`echo ${DEF_STR} " MAXMSGL(${MAXMSGL})"`
		DEF_STR=`echo ${DEF_STR} " DISCINT(${DISCINT})"`
		DEF_STR=`echo ${DEF_STR} " XMITQ(CM${STR_CD}.${TYPE}.XQ)"`
		DEF_STR=`echo ${DEF_STR} " HBINT(${HBINT})"`
		DEF_STR=`echo ${DEF_STR} " SHORTRTY(${SHORTRTY})"`
		DEF_STR=`echo ${DEF_STR} " SHORTTMR(${SHORTTMR})"`
		DEF_STR=`echo ${DEF_STR} " BATCHSZ(${BATCHSZ})"`
		DEF_STR=`echo ${DEF_STR} " COMPMSG(${COMPMSG})"`
		DEF_STR=`echo ${DEF_STR} " REPLACE"`

		AMQ_CODE=`echo "DIS CHL(${OBJ_NAME})" | ${MQSC_PATH}/mqsc -m ${HUB02_QM} -l -c ${HUB02_CH} -h ${HUB02_IP} | grep AMQ8147 | wc -l`
		if [ $AMQ_CODE -eq 1 ]
		then
			echo "${DEF_STR}" | ${MQSC_PATH}/mqsc -m ${HUB02_QM} -l -c ${HUB02_CH} -h ${HUB02_IP} 1>/dev/null
			echo "define sdr chl(${OBJ_NAME}) completed(isNew=Yes)"
		else
			echo "define sdr chl(${OBJ_NAME}) completed(isNew=No)"
		fi
	done

}

#-----------------------------------------------------------#
# DEFINE - XMITQ                                            #
# - HUB02에 생성한다.                                       #
# - Batch/Non-Batch 용 2개의 XMITQ를 생성함                 #
#-----------------------------------------------------------#
def_xmitq()
{
	for TYPE in ${INTF_PROCESS_TYPE}
	do
		OBJ_NAME="CM${STR_CD}.${TYPE}.XQ"
		
		DEF_STR=""
		DEF_STR=`echo ${DEF_STR} "DEF QL(${OBJ_NAME})"`
		DEF_STR=`echo ${DEF_STR} " MAXDEPTH(${MAXDEPTH})"`
		DEF_STR=`echo ${DEF_STR} " MAXMSGL(${MAXMSGL})"`
		DEF_STR=`echo ${DEF_STR} " DEFPSIST(${DEFPSIST})"`
		DEF_STR=`echo ${DEF_STR} " USAGE(XMITQ)"`
		DEF_STR=`echo ${DEF_STR} " TRIGGER"`
		DEF_STR=`echo ${DEF_STR} " INITQ(SYSTEM.CHANNEL.INITQ)"`
		DEF_STR=`echo ${DEF_STR} " TRIGDATA(${HUB02_QM}.CM${STR_CD}.${TYPE})"`
		DEF_STR=`echo ${DEF_STR} " REPLACE"`
		
		AMQ_CODE=`echo "DIS QL(${OBJ_NAME})" | ${MQSC_PATH}/mqsc -m ${HUB02_QM} -l -c ${HUB02_CH} -h ${HUB02_IP} | grep AMQ8147 | wc -l`
		if [ $AMQ_CODE -eq 1 ]
		then
			echo "${DEF_STR}" | ${MQSC_PATH}/mqsc -m ${HUB02_QM} -l -c ${HUB02_CH} -h ${HUB02_IP} 1>/dev/null	
			echo "define xmitq(${OBJ_NAME}) completed(isNew=Yes)"
		else
			echo "define xmitq(${OBJ_NAME}) completed(isNew=No)"
		fi		
	done
}

#-----------------------------------------------------------#
# DEFINE - REMOTE QUEUE                                     #
# - HUB02에 생성한다.                                       #
# - Batch/Non-Batch 용 2개의 REMOTEQ를 생성함               #
#-----------------------------------------------------------#
def_remoteq()
{
	for TYPE in ${INTF_PROCESS_TYPE}
	do
		OBJ_NAME="CM${STR_CD}.${TYPE}.OT"
		
		DEF_STR=""
		DEF_STR=`echo ${DEF_STR} "DEF QR(${OBJ_NAME})"`
		DEF_STR=`echo ${DEF_STR} " DEFPSIST(${DEFPSIST})"`
		DEF_STR=`echo ${DEF_STR} " RQMNAME(CM${STR_CD})"`
		DEF_STR=`echo ${DEF_STR} " RNAME('')"`
		DEF_STR=`echo ${DEF_STR} " XMITQ(CM${STR_CD}.${TYPE}.XQ)"`
		DEF_STR=`echo ${DEF_STR} " REPLACE"`
		
		AMQ_CODE=`echo "DIS QR(${OBJ_NAME})" | ${MQSC_PATH}/mqsc -m ${HUB02_QM} -l -c ${HUB02_CH} -h ${HUB02_IP} | grep AMQ8147 | wc -l`
		if [ $AMQ_CODE -eq 1 ]
		then
			echo "${DEF_STR}" | ${MQSC_PATH}/mqsc -m ${HUB02_QM} -l -c ${HUB02_CH} -h ${HUB02_IP} 1>/dev/null
			echo "define remoteq(${OBJ_NAME}) completed(isNew=Yes)"
		else
			echo "define remoteq(${OBJ_NAME}) completed(isNew=No)"
		fi		
	done		
}

#-----------------------------------------------------------#
# DEFINE - RQSTR CHANNEL                                    #
# - 점포코드 끝자리의 홀수/짝수 확인후                      #
#   홀수이면 HUB01, 짝수이면 HUB02 에 생성한다              #
# - 이벤트 메세지 처리용 IFM 채널 생성                      #
#-----------------------------------------------------------#
def_rqstr_chl()
{
	HUB_QM=""
	HUB_IP=""
	HUB_CH=""
	
	if [ ${parity_check} -eq 0 ]
	then
		HUB_QM=${HUB02_QM}
		HUB_IP=${HUB02_IP}
		HUB_CH=${HUB02_CH}
	else
		HUB_QM=${HUB01_QM}
		HUB_IP=${HUB01_IP}
		HUB_CH=${HUB01_CH}
	fi
	
	for TYPE in ${INTF_PROCESS_TYPE}
	do
		OBJ_NAME="CM${STR_CD}.${HUB_QM}.${TYPE}"
		
		DEF_STR=""
		DEF_STR=`echo ${DEF_STR} "DEF CHL(${OBJ_NAME}) CHLTYPE(RQSTR)"`
		DEF_STR=`echo ${DEF_STR} " CONNAME('${SVR_IP}(1414)')"`
		DEF_STR=`echo ${DEF_STR} " MAXMSGL(${MAXMSGL})"`
		DEF_STR=`echo ${DEF_STR} " HBINT(${HBINT})"`
		DEF_STR=`echo ${DEF_STR} " BATCHSZ(${BATCHSZ})"`
		DEF_STR=`echo ${DEF_STR} " COMPMSG(${COMPMSG})"`
		DEF_STR=`echo ${DEF_STR} " REPLACE"`
		
		AMQ_CODE=`echo "DIS CHL(${OBJ_NAME})" | ${MQSC_PATH}/mqsc -m ${HUB_QM} -l -c ${HUB_CH} -h ${HUB_IP} | grep AMQ8147 | wc -l`
		if [ $AMQ_CODE -eq 1 ]
		then
			echo "${DEF_STR}" | ${MQSC_PATH}/mqsc -m ${HUB_QM} -l -c ${HUB_CH} -h ${HUB_IP} 1>/dev/null
			echo "define rqstr chl(${OBJ_NAME}) completed(isNew=Yes)"
		else
			echo "define rqstr chl(${OBJ_NAME}) completed(isNew=No)"
		fi			
	done
	
	OBJ_NAME="CM${STR_CD}.${IFM_QM}.N1"
	
	DEF_STR=""
	DEF_STR=`echo ${DEF_STR} "DEF CHL(${OBJ_NAME}) CHLTYPE(RQSTR)"`
	DEF_STR=`echo ${DEF_STR} " CONNAME('${SVR_IP}(1414)')"`
	DEF_STR=`echo ${DEF_STR} " MAXMSGL(${MAXMSGL})"`
	DEF_STR=`echo ${DEF_STR} " HBINT(${HBINT})"`
	DEF_STR=`echo ${DEF_STR} " COMPMSG(${COMPMSG})"`
	DEF_STR=`echo ${DEF_STR} " REPLACE"`
	
	AMQ_CODE=`echo "DIS CHL(${OBJ_NAME})" | ${MQSC_PATH}/mqsc -m ${IFM_QM} -l -c ${IFM_CH} -h ${IFM_IP} | grep AMQ8147 | wc -l`
	if [ $AMQ_CODE -eq 1 ]
	then
		echo "${DEF_STR}" | ${MQSC_PATH}/mqsc -m ${IFM_QM} -l -c ${IFM_CH} -h ${IFM_IP} 1>/dev/null
		echo "define rqstr chl(${OBJ_NAME}) completed(isNew=Yes)"
	else
		echo "define rqstr chl(${OBJ_NAME}) completed(isNew=No)"
	fi
}

#-----------------------------------------------------------#
# DELETE SDR CHANNEL                                        #
# - HUB02에 삭제한다.                                       #
# - Batch/Non-Batch 용 2개의 채널을 삭제함                  #
#-----------------------------------------------------------#
del_sdr_chl()
{
	for TYPE in ${INTF_PROCESS_TYPE}
	do
		OBJ_NAME="${HUB02_QM}.CM${STR_CD}.${TYPE}"
		echo "STOP CHL(${OBJ_NAME}) MODE(TERMINATE)" | ${MQSC_PATH}/mqsc -m ${HUB02_QM} -l -c ${HUB02_CH} -h ${HUB02_IP} 1>/dev/null	
		sleep 2
		echo "DELETE CHL(${OBJ_NAME})"               | ${MQSC_PATH}/mqsc -m ${HUB02_QM} -l -c ${HUB02_CH} -h ${HUB02_IP} 1>/dev/null	
		echo "delete sdr chl(${OBJ_NAME}) completed"
	done
}

#-----------------------------------------------------------#
# DELETE - XMITQ                                            #
# - HUB02에 삭제한다.                                       #
# - Batch/Non-Batch 용 2개의 XMITQ를 삭제함                 #
#-----------------------------------------------------------#
del_xmitq()
{
	for TYPE in ${INTF_PROCESS_TYPE}
	do
		OBJ_NAME="CM${STR_CD}.${TYPE}.XQ"
		echo "DELETE QL(${OBJ_NAME})" | ${MQSC_PATH}/mqsc -m ${HUB02_QM} -l -c ${HUB02_CH} -h ${HUB02_IP} 1>/dev/null			
		echo "delete xmitq(${OBJ_NAME}) completed"		
	done
}

#-----------------------------------------------------------#
# DELETE - REMOTE QUEUE                                     #
# - HUB02에 삭제한다.                                       #
# - Batch/Non-Batch 용 2개의 REMOTEQ를 삭제함               #
#-----------------------------------------------------------#
del_remoteq()
{
	for TYPE in ${INTF_PROCESS_TYPE}
	do
		OBJ_NAME="CM${STR_CD}.${TYPE}.OT"
		echo "DELETE QR(${OBJ_NAME})" | ${MQSC_PATH}/mqsc -m ${HUB02_QM} -l -c ${HUB02_CH} -h ${HUB02_IP} 1>/dev/null
		echo "delete remoteq(${OBJ_NAME}) completed"		
	done
}

#-----------------------------------------------------------#
# DELETE - RQSTR CHANNEL                                    #
# - 점포코드 끝자리의 홀수/짝수 확인후                      #
#   홀수이면 HUB01, 짝수이면 HUB02 에 삭제한다              #
# - 이벤트 메세지 처리용 IFM 채널 삭제                      #
#-----------------------------------------------------------#
del_rqstr_chl()
{
	HUB_QM=""
	HUB_IP=""
	HUB_CH=""
	
	if [ ${parity_check} -eq 0 ]
	then
		HUB_QM=${HUB02_QM}
		HUB_IP=${HUB02_IP}
		HUB_CH=${HUB02_CH}
	else
		HUB_QM=${HUB01_QM}
		HUB_IP=${HUB01_IP}
		HUB_CH=${HUB01_CH}
	fi
	
	for TYPE in ${INTF_PROCESS_TYPE}
	do
		OBJ_NAME="CM${STR_CD}.${HUB_QM}.${TYPE}"
		echo "DELETE CHL(${OBJ_NAME})" | ${MQSC_PATH}/mqsc -m ${HUB_QM} -l -c ${HUB_CH} -h ${HUB_IP} 1>/dev/null
		echo "delete rqstr chl(${OBJ_NAME}) completed"
	done
	
	OBJ_NAME="CM${STR_CD}.${IFM_QM}.N1"
	echo "DELETE CHL(${OBJ_NAME})" | ${MQSC_PATH}/mqsc -m ${IFM_QM} -l -c ${IFM_CH} -h ${IFM_IP} 1>/dev/null
	echo "delete rqstr chl(${OBJ_NAME}) completed"
}

#-----------------------------------------------------------#
# 생성 모듈                                                 #
#-----------------------------------------------------------#
object_define()
{
	def_sdr_chl
	def_rqstr_chl
	def_xmitq
	def_remoteq
}

#-----------------------------------------------------------#
# 삭제 모듈                                                 #
#-----------------------------------------------------------#
object_delete()
{
	del_sdr_chl
	del_xmitq
	del_remoteq	
	del_rqstr_chl
}

#-----------------------------------------------------------#
# Validation Check                                          #
#-----------------------------------------------------------#
validation_check()
{
	if [ -z "${STR_CD}" ]
	then
	  echo "STR_CD 가 누락되었습니다."
	  syntax
	fi
	
	if [ -z "${SVR_IP}" ]
	then
	  echo "IP 가 누락되었습니다."
	  syntax
	fi
	
	if [ -z "${CMD}" ]
	then
	  echo "COMMND 가 누락되었습니다."
	  syntax
	fi	
}

#-----------------------------------------------------------#
# Arguments                                                 #
#-----------------------------------------------------------#
STR_CD=$1
SVR_IP=$2
CMD=$3

#-----------------------------------------------------------#
# Main                                                      #
#-----------------------------------------------------------#
validation_check
parity_value=`expr substr ${STR_CD} 5 1`
parity_check=`expr ${parity_value} % 2`
DATE=`date +"%Y-%m-%d %H:%M:%S"`
case ${CMD} in
	I)
	echo "#-----------------------------------------------------------#"
	echo "# Define MQ Object (STR_CD : ${STR_CD})                      "
	echo "# DATE : $DATE                                               "
	echo "#-----------------------------------------------------------#"
	object_define parity_check
	;;
	
	D)
	echo "#-----------------------------------------------------------#"
	echo "# Delete MQ Object (STR_CD : ${STR_CD})                      "
	echo "# DATE : $DATE                                               "
	echo "#-----------------------------------------------------------#"
	object_delete parity_check
	;;

	*) syntax
	break;;
esac


#echo `expr substr ${STR_CD} 5 1`
#echo "nothing"
exit 0