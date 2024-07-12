# INIT
count=0
FILTER_INF_ID="SM_CREDCD_DPST_FIBT"
FILTER_INF_NM="입금반송자료수신"
LAST_Q_SIZE=""

# SEND SMS FTP SERVER INFO
# OP FTP
#FTP_SVR_IP="165.244.243.77"
#FTP_USER="scmqm"
#FTP_PSWD="eai2311!@"
#FTP_SAVE_DIR="/MQHA/mte/scadapter/log/SMS"

# DEV FTP
FTP_SVR_IP="10.56.38.149"
FTP_USER="scmqm"
FTP_PSWD="gsmqm001"
FTP_SAVE_DIR="/MQHA/mte/scadapter/log/SMS"

# LOG DATE
WORK_DATE=`date +%y%m%d`
LOG_WORK_DATE=`date +%Y/%m/%d`
LOG_WORK_TIME=`date +%H:%M:%S`
LOG_WORK_TIME2=`date +%H%M%S`

# SMS SENT LOG FILE PATH
SMS_LOG_DIR=/MQHA/data/control/tmp

#GET PROGRAM PATH
GET_INF_ID_PROGRAM_PATH=/MQHA/bin

# GET DEAD Q INF_ID INFO (INF_ID, DATA SIZE)
${GET_INF_ID_PROGRAM_PATH}/amqsbcg0_get_infid DEAD.DQ EAIBK3P > ${GET_INF_ID_PROGRAM_PATH}/DEAD_Q_CHECK_LIST

# FILTER FILTER_INF_ID
while read DATA
do
	set -A DATA_LIST $DATA
	
	# if matched FILTER_INF_ID
	if [ ${DATA_LIST[0]} == ${FILTER_INF_ID} ]; then
		count=$(($count+1))
		LAST_Q_SIZE="${DATA_LIST[1]}${DATA_LIST[2]}"
	fi

done < ${GET_INF_ID_PROGRAM_PATH}/DEAD_Q_CHECK_LIST

if [ ${count} -ge 1 ]; then

	echo "${FILTER_INF_NM} ${LAST_Q_SIZE} ${count}건 발생, 파일 업로드 후 DEAD.DQ 삭제해 주세요." > ${SMS_LOG_DIR}/BC_SMS_${WORK_DATE}${LOG_WORK_TIME2}.log
		
# 아래 부분은 왼쪽으로 붙여서 작성해야 합니다.               
ftp -n ${FTP_SVR_IP} << EOF
        user ${FTP_USER} ${FTP_PSWD}
        bin
        lcd ${SMS_LOG_DIR}
        cd ${FTP_SAVE_DIR}
        put BC_SMS_${WORK_DATE}${LOG_WORK_TIME2}.log
        bye
EOF

fi