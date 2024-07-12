########## 기동 쉘 스크립트 교체 ##########
hamqsi_start_broker
hamqsi_start_broker_as
hamqsi_stop_broker
hamqsi_stop_broker_as

########## 시작(EAIBK#P_start.sh) ##########
MQUSER=mqm
BKUSER=mqsi
QMNAME=EAIBK3P
BKNAME=EAIBK3P
#DBINST=mqsi --삭제
#DBNAME=EAIBK3DB --삭제
MQEQM=GW31

(기존)
$MQHA_BIN/hamqsi_start_broker_as $BKNAME $QMNAME $BKUSER $DBINST $DBNAME

(변경)
$MQHA_BIN/hamqsi_start_broker_as $BKNAME $QMNAME $MQUSER $MQUSER
예) /MQHA/bin/hamqsi_start_broker_as EAIBK2P EAIBK2P mqm mqsi

########## 정지(EAIBK#P_stop.sh) ##########
#Global Variable
MQUSER=mqm
BKUSER=mqsi
QMNAME=EAIBK3P
BKNAME=EAIBK3P
#DBINST=mqsi --삭제
#DBNAME=EAIBK3DB --삭제
MQEQM=GW31
TIMEOUT=30

(기존)
su $BKUSER -c "$MQHA_BIN/hamqsi_stop_broker_as $BKNAME $QMNAME $BKUSER $DBINST $TIMEOUT"

(변경)
su $BKUSER -c "$MQHA_BIN/hamqsi_stop_broker_as $BKNAME $QMNAME $MQUSER $BKUSER $TIMEOUT"
예) /MQHA/bin/hamqsi_stop_broker_as EAIBK2P EAIBK2P mqm mqsi 30

########## 필요 없는 쉘 스크립트 ##########
hamqsi_start_cfgmgr
hamqsi_start_cfgmgr_as
hamqsi_start_uns
hamqsi_start_uns_as
hamqsi_stop_cfgmgr
hamqsi_stop_cfgmgr_as
hamqsi_stop_uns
hamqsi_stop_uns_as
hamqsiaddcfgmgrstandby
hamqsicreatecfgmgr
hamqsicreateusernameserver
hamqsideletecfgmgr
hamqsideleteusernameserver
hamqsiremovecfgmgrstandby
hamqsiremoveunsstandby
