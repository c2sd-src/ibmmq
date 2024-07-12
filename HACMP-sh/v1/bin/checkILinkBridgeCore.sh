################################################################################
# ILinkBridge core üũ�� ���Դϴ�
################################################################################

#################################################################################
# 1. ���� �����
#################################################################################

ILINK_BRIDGE_HOME=/mqm/data/mi/ILinkBridge

# Root �α� ���丮
BASE_DIR=$ILINK_BRIDGE_HOME

# ��¥üũ
WORK_DATE=`date +%y%m%d`

# LOG �� ��¥
LOG_WORK_DATE=`date +%Y/%m/%d`

# SMS �� LOG �� ������ ���� IP (SCDB)
FTP_SVR_IP="165.244.243.11"
FTP_USER="mqm"
FTP_PSWD="gsmqm001"
FTP_SAVE_DIR="/MQHA/mte/adapter/log/SMS"

# SMS �߼ۿ� �α� ���ϰ��
SMS_LOG_DIR=/MQHA/data/control/tmp

# String ����Ʈ
CHECK_FILE_NAME="core"

# SMS Flag
SMS_SEND_YN=N

#################################################################################
# 1. ������ �����ϴ��� üũ
################ũ###############################################################

CORE_CNT=`ls -l ${BASE_DIR}/${CHECK_FILE_NAME}* | wc -l `

LOG_WORK_TIME=`date +%H:%M:%S`

# ����ġ �̻��� ������ �߻��� ���
if [ "${CORE_CNT}" -gt "0" ]
then
		SMS_SEND_YN=Y
		echo "[${LOG_WORK_DATE} ${LOG_WORK_TIME}] CORE_CNT [${CORE_CNT}] SMS_SEND_YN [${SMS_SEND_YN}]"
		break;
fi
echo "[${LOG_WORK_DATE} ${LOG_WORK_TIME}] CORE_CNT [${CORE_CNT}] SMS_SEND_YN [${SMS_SEND_YN}]"


echo $SMS_SEND_YN

# SMS �߼�ó��
if [ "${SMS_SEND_YN}" == "Y" ]
then

        # ���� �ð����� �޽��� �߼�
        LOG_WORK_TIME=`date +%H:%M:%S`
        LOG_WORK_TIME2=`date +%H%M%S`
        echo "[${LOG_WORK_DATE} ${LOG_WORK_TIME}] EAIBK3P $ILINK_BRIDGE_HOME/core �߻� !!" > ${SMS_LOG_DIR}/SMS_GW_${WORK_DATE}${LOG_WORK_TIME2}.log

# �Ʒ� �κ��� �������� �ٿ��� �ۼ��ؾ� �մϴ�.               
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
