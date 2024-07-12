ILINK_HOME=/mqm/data/mi/ilink
#ILINK_HOME=/MQHA/data/mi/ilink

QM=$1
SERVERIP=$2
SERVERPORT=$3

if [ $# -ne "3" ]
then
  echo "사용법 : qdepth.sh [큐매니저명] [IP Address] [ILink Server Port]"
  echo "[큐매니저명] = GW31 ~ GW40"
  echo "qdepth.sh GW31 127.0.0.1 9998"
  exit 0
fi

while true
do
echo `date`
echo "============================================="
echo "ILink QM($QM) Curdepth 0 Over Queue List"
echo "ILink Server IP : ($SERVERIP), Server Port : ($SERVERPORT)"
echo "============================================="
echo 'use '$QM'
list q
exit ' | $ILINK_HOME/ILinkCon $SERVERIP $SERVERPORT | grep -v '(    0)' | grep LOCAL

sleep 5
done

