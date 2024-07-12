ILINK_HOME=/mqm/data/mi/ilink
GW_HOME=/home/mqm/mte/gateway
#ILINK_HOME=/MQHA/data/mi/ilink
#GW_HOME=/MQHA/mte/gateway

QM=$1
Queue=$2

if [ $# -ne "2" ]
then
  echo "사용법 : qclear.sh [큐매니저명] [큐명칭t]"
  echo "[큐매니저명] = GW31 ~ GW40"
  echo "[큐명칭] = TO.[최초점포코드][POS코드]D.LQ"
  echo "ex) qclear.sh GW31 TO.VP4491D.LQ"
  exit 0
fi

echo "============================================="
echo `date`
echo "ILink QManager : ($1)"
echo "ILink Queue : ($2)"

echo 'use '$QM'
flush q '$Queue'
exit ' | $ILINK_HOME/ILinkCon 127.0.0.1 9998
echo "수행결과는 $GW_HOME/bin/qdep.sh $QM $Queue 실행하세요."
echo "============================================="
