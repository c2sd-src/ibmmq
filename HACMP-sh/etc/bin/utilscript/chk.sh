#!/bin/ksh

while true
do
echo "==================== [($1) START : `date` ] ========================="
ps -ef | grep mteserver | grep mqm | grep -v grep 
ps -p $1 -ovsz,pmem,pcpu
#ps auxwww | grep mqm | grep ETR
echo "==================== [($1) E N D : `date` ] ========================="
echo ""
sleep 10
done

