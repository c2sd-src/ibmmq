########## �⵿ �� ��ũ��Ʈ ��ü ##########
hamqsi_start_broker
hamqsi_start_broker_as
hamqsi_stop_broker
hamqsi_stop_broker_as

########## ����(EAIBK#P_start.sh) ##########
MQUSER=mqm
BKUSER=mqsi
QMNAME=EAIBK3P
BKNAME=EAIBK3P
#DBINST=mqsi --����
#DBNAME=EAIBK3DB --����
MQEQM=GW31

(����)
$MQHA_BIN/hamqsi_start_broker_as $BKNAME $QMNAME $BKUSER $DBINST $DBNAME

(����)
$MQHA_BIN/hamqsi_start_broker_as $BKNAME $QMNAME $MQUSER $MQUSER
��) /MQHA/bin/hamqsi_start_broker_as EAIBK2P EAIBK2P mqm mqsi

########## ����(EAIBK#P_stop.sh) ##########
#Global Variable
MQUSER=mqm
BKUSER=mqsi
QMNAME=EAIBK3P
BKNAME=EAIBK3P
#DBINST=mqsi --����
#DBNAME=EAIBK3DB --����
MQEQM=GW31
TIMEOUT=30

(����)
su $BKUSER -c "$MQHA_BIN/hamqsi_stop_broker_as $BKNAME $QMNAME $BKUSER $DBINST $TIMEOUT"

(����)
su $BKUSER -c "$MQHA_BIN/hamqsi_stop_broker_as $BKNAME $QMNAME $MQUSER $BKUSER $TIMEOUT"
��) /MQHA/bin/hamqsi_stop_broker_as EAIBK2P EAIBK2P mqm mqsi 30

########## �ʿ� ���� �� ��ũ��Ʈ ##########
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
