#!/bin/ksh

QMGR=$1

if [ $# -eq 0 ]
then
        echo "\n"
        echo "usage : $0 [QMNAME]"
        echo "\n"
        exit
fi

i=0
cat /home/mqm/bin/tmp/list_$QMGR | while read pos_list
do
  cnt=`ls -al /mqm/data/MQe/qmgrs/$QMGR/Queues/$QMGR/$pos_list | wc -l`
  i=`expr $i + $cnt`
done

echo "$QMGR Queue Depth : $i" 
