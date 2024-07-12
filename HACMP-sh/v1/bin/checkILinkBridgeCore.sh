################################################################################
# ILinkBridge core 체크용 쉘입니다
################################################################################

#################################################################################
# 1. 변수 선언부
#################################################################################

ILINK_BRIDGE_HOME=/mqm/data/mi/ILinkBridge

# Root 로그 디렉토리
BASE_DIR=$ILINK_BRIDGE_HOME

# 날짜체크
WORK_DATE=`date +%y%m%d`

# LOG 용 날짜
LOG_WORK_DATE=`date +%Y/%m/%d`

# SMS 용 LOG 를 전송할 서버 IP (SCDB)
FTP_SVR_IP="165.244.243.11"
FTP_USER="mqm"
FTP_PSWD="gsmqm001"
FTP_SAVE_DIR="/MQHA/mte/adapter/log/SMS"

# SMS 발송용 로그 파일경로
SMS_LOG_DIR=/MQHA/data/control/tmp

# String 리스트
CHECK_FILE_NAME="core"

# SMS Flag
SMS_SEND_YN=N

#################################################################################
# 1. 파일이 존재하는지 체크
################크###############################################################

CORE_CNT=`ls -l ${BASE_DIR}/${CHECK_FILE_NAME}* | wc -l `

LOG_WORK_TIME=`date +%H:%M:%S`

# 기준치 이상의 에러가 발생한 경우
if [ "${CORE_CNT}" -gt "0" ]
then
		SMS_SEND_YN=Y
		echo "[${LOG_WORK_DATE} ${LOG_WORK_TIME}] CORE_CNT [${CORE_CNT}] SMS_SEND_YN [${SMS_SEND_YN}]"
		break;
fi
echo "[${LOG_WORK_DATE} ${LOG_WORK_TIME}] CORE_CNT [${CORE_CNT}] SMS_SEND_YN [${SMS_SEND_YN}]"


echo $SMS_SEND_YN

# SMS 발송처리
if [ "${SMS_SEND_YN}" == "Y" ]
then

        # 현재 시각으로 메시지 발송
        LOG_WORK_TIME=`date +%H:%M:%S`
        LOG_WORK_TIME2=`date +%H%M%S`
        echo "[${LOG_WORK_DATE} ${LOG_WORK_TIME}] EAIBK3P $ILINK_BRIDGE_HOME/core 발생 !!" > ${SMS_LOG_DIR}/SMS_GW_${WORK_DATE}${LOG_WORK_TIME2}.log

# 아래 부분은 왼쪽으로 붙여서 작성해야 합니다.               
#ftp -n ${FTP_SVR_IP} << EOF
#        user ${FTP_USER} ${FTP_PSWD}
#        bin
#        lcd ${SMS_LOG_DIR}
#        cd ${FTP_SAVE_DIR}
#        put SMS_GW_${WORK_DATE}${LOG_WORK_TIME2}.log
#        bye
#EOF
                
fi
                        

exit 0
