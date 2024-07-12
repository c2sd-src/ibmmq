ILINK_HOME=/mqm/data/mi/ilink
GW_HOME=/home/mqm/mte/gateway
#ILINK_HOME=/MQHA/data/mi/ilink
#GW_HOME=/MQHA/mte/gateway

QM=$1
Queue=$2

if [ $# -ne "2" ]
then
  echo "���� : qclear.sh [ť�Ŵ�����] [ť��Īt]"
  echo "[ť�Ŵ�����] = GW31 ~ GW40"
  echo "[ť��Ī] = TO.[���������ڵ�][POS�ڵ�]D.LQ"
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
echo "�������� $GW_HOME/bin/qdep.sh $QM $Queue �����ϼ���."
echo "============================================="
