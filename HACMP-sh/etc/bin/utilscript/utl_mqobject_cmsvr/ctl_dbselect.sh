#!/bin/ksh
export LANG=C
#################################################################
# script      : ctl_dbselect.sh
# description : 
#  - 통신서버 신규/폐점 점보 정보를 추출하여 output 파일 생성
#################################################################

#-----------------------------------------------------------#
# Define Variable                                           #
#                                                           #
#-----------------------------------------------------------#
DATA_DIR=/eai1/data
SCRIPT_HOME=~mqm/bin/utilscript/utl_mqobject_cmsvr

. ${DATA_DIR}/mte/.mte_profile
. ${SCRIPT_HOME}/.server_info

DATE=`date +"%y%m%d_%H%M%S"`
OUTPUT_FILE_NM=$1

if [ -z "$OUTPUT_FILE_NM" ]
then
  echo "Usage : $0 [OUTPUT_FILE_NM]"
  exit 1
fi

# DB 접속 후 수행결과를 체크파일에 기록
$ORACLE_HOME/bin/sqlplus -s "${DB_USER}/${DB_PASS}@${DB_CONN}"<<END>$OUTPUT_FILE_NM

SET serverout on
SET echo off
SET feedback off
SET linesize 150

DECLARE
	vstr_cd VARCHAR2(5);
	vstr_ip VARCHAR2(15);
	vop     VARCHAR2(1);
	
	CURSOR eai_cursor IS
	  -----------------------------------------------------------------
		SELECT A.STR_CD
		       ,B.STR_IP
		       --,A.OPENSTR_DT
		       --,A.SALE_EDT
		       ,CASE WHEN A.SALE_EDT <= TO_CHAR(SYSDATE - 15, 'YYYYMMDD')
		             THEN 'D'
		             ELSE 'I'
		        END AS OP
		FROM TS_MA_STR A, TS_MA_STR_IP B
		WHERE A.STR_CD = B.STR_CD
		      AND A.STR_CD IN
		      (
		       SELECT STR_CD
		       FROM TS_MA_STR
		       WHERE OPENSTR_DT <= TO_CHAR(SYSDATE + 30, 'YYYYMMDD')
		             AND REAL_STR_YN = 'Y'
		             AND STKLDGR_OCCR_YN = 'Y'
		             AND USE_YN = 'Y'
		             AND (NEW_FORM_STR_SP_CD IS NULL OR NEW_FORM_STR_SP_CD NOT IN ('MD', 'FC'))
			     AND REGEXP_LIKE(STR_CD, '^.[1-4]')
		      )
		      AND B.DVIC_SP_CD = 'SC'
		ORDER BY STR_CD;
	  -----------------------------------------------------------------
	BEGIN
		dbms_output.put_line('#!/bin/ksh');
		dbms_output.put_line('SCRIPT_HOME=~mqm/bin/utilscript/utl_mqobject_cmsvr');
		OPEN eai_cursor;
		LOOP FETCH eai_cursor INTO vstr_cd, vstr_ip, vop;
			EXIT WHEN eai_cursor%NOTFOUND;
			dbms_output.put_line('\${SCRIPT_HOME}/ctl_mqobject.sh ' \
			                     ||vstr_cd||' '||vstr_ip||' '||vop|| \
			                     ' 1>>\${SCRIPT_HOME}/output/ctl_mqobject.out_${DATE}');
		END LOOP;
   	CLOSE eai_cursor;
	END;
/
quit
END
