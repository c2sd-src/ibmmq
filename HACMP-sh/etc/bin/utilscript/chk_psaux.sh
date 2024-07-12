#!/bin/ksh
export LANG=C

TITLE="USER        PID %CPU %MEM SZ RSS TTY STAT STIME TIME COMMAND"


#-----------------------------------------------------------#
# QManager Resource                                         #
#-----------------------------------------------------------#
QMGR_CHECK()
{

 #CPU/Memory Usage
 CPU_TOTAL=0
 MEM_TOTAL=0
 SZ_TOTAL=0
 
 RESOURCES=`ps auxwww | grep mqm | egrep "amq|runmq" | egrep -v "grep" | awk '{print $3 "-" $4 "-" $5}'`
 for RESOURCE in $RESOURCES
 do
   CPU=`echo $RESOURCE | awk -F"-" '{print $1}'`
   MEM=`echo $RESOURCE | awk -F"-" '{print $2}'`
   SZ=`echo $RESOURCE | awk -F"-" '{print $3}'`

   CPU_TOTAL=`echo $CPU_TOTAL $CPU | awk '{printf "%.2f", $1 + $2}'`
   MEM_TOTAL=`echo $MEM_TOTAL $MEM | awk '{printf "%.2f", $1 + $2}'`
   SZ_TOTAL=`expr $SZ_TOTAL + $SZ`
 done 
 
 #Shared Memroy
 SHM_TOTAL=0
 SHMS=`ipcs -ma | grep mqm | egrep -v "D-" | awk '{print $10}'`
 for SHM in $SHMS
 do
   SHM_TOTAL=`expr $SHM_TOTAL + $SHM`
 done
 SHM_TOTAL=`expr $SHM_TOTAL / 1024`
 
 echo "------------------------------------------------------------------------------------"
 echo " QManager Resource Check                                                            " 
 echo " CPU(%)  : $CPU_TOTAL                                                               "
 echo " MEM(%)  : $MEM_TOTAL                                                               " 
 echo " MEM(Kb) : SZ( $SZ_TOTAL ) + SHM( $SHM_TOTAL ) = `expr $SZ_TOTAL + $SHM_TOTAL` Kbyte"
 echo "------------------------------------------------------------------------------------"
 echo "USER          PID %CPU %MEM   SZ  RSS    TTY STAT    STIME  TIME  COMMAND"
# ps auxwww | egrep "mqm" | egrep "amq|runmq" | egrep -v "grep" 
 
}

#-----------------------------------------------------------#
# Broker Resource                                         #
#-----------------------------------------------------------#
BROKER_CHECK()
{

 #CPU/Memory Usage
 CPU_TOTAL=0
 MEM_TOTAL=0
 SZ_TOTAL=0
 
 RESOURCES=`ps auxwww | grep mqsi | egrep "bip|DataFlow" | egrep -v "grep" | awk '{print $3 "-" $4 "-" $5}'`
 for RESOURCE in $RESOURCES
 do
   CPU=`echo $RESOURCE | awk -F"-" '{print $1}'`
   MEM=`echo $RESOURCE | awk -F"-" '{print $2}'`
   SZ=`echo $RESOURCE | awk -F"-" '{print $3}'`

   CPU_TOTAL=`echo $CPU_TOTAL $CPU | awk '{printf "%.2f", $1 + $2}'`
   MEM_TOTAL=`echo $MEM_TOTAL $MEM | awk '{printf "%.2f", $1 + $2}'`
   SZ_TOTAL=`expr $SZ_TOTAL + $SZ`
 done 
 
 #Shared Memroy
 SHM_TOTAL=0
 SHMS=`ipcs -ma | grep mqsi | egrep -v "D-" | awk '{print $10}'`
 for SHM in $SHMS
 do
   SHM_TOTAL=`expr $SHM_TOTAL + $SHM`
 done
 SHM_TOTAL=`expr $SHM_TOTAL / 1024`
 
 echo "------------------------------------------------------------------------------------"
 echo " Broker Resource Check                                                            " 
 echo " CPU(%)  : $CPU_TOTAL                                                               "
 echo " MEM(%)  : $MEM_TOTAL                                                               " 
 echo " MEM(Kb) : SZ( $SZ_TOTAL ) + SHM( $SHM_TOTAL ) = `expr $SZ_TOTAL + $SHM_TOTAL` Kbyte"
 echo "------------------------------------------------------------------------------------"
 echo "USER          PID %CPU %MEM   SZ  RSS    TTY STAT    STIME  TIME  COMMAND"
 ps auxwww | egrep "mqsi" | egrep "bip|DataFlow" | egrep -v "grep" 
 
}


#-----------------------------------------------------------#
# MTE Adapter Resource                                      #
#-----------------------------------------------------------#
ADT_CHECK()
{

 #CPU/Memory Usage
 CPU_TOTAL=0
 MEM_TOTAL=0
 SZ_TOTAL=0
 ADT_CNT=0
 
 RESOURCES=`ps auxwww | grep mqm | egrep "xml" | egrep -v "grep|amq|runmq|defunct" | awk '{print $3}'`
 for CPU in $RESOURCES
 do
   CPU_TOTAL=`echo $CPU_TOTAL $CPU | awk '{printf "%.2f", $1 + $2}'`
 done

 RESOURCES=`ps auxwww | grep mqm | egrep "xml" | egrep -v "grep|amq|runmq|defunct" | awk '{print $4}'`
 for MEM in $RESOURCES
 do
   MEM_TOTAL=`echo $MEM_TOTAL $MEM | awk '{printf "%.2f", $1 + $2}'`
 done 
 
 RESOURCES=`ps auxwww | grep mqm | egrep "xml" | egrep -v "grep|amq|runmq|defunct" | awk '{print $5}'`
 for SZ in $RESOURCES
 do
   SZ_TOTAL=`expr $SZ_TOTAL + $SZ`
   ADT_CNT=`expr $ADT_CNT + 1`
 done   
 
 echo "------------------------------------------------------------------------------------"
 echo " MTE Adapter Resource Check                                                         " 
 echo " CPU(%)  : $CPU_TOTAL                                                               "
 echo " MEM(%)  : $MEM_TOTAL                                                               " 
 echo " MEM(Kb) : $SZ_TOTAL Kbyte                                                          "
 echo " Count   : $ADT_CNT                                                                 "
 echo "------------------------------------------------------------------------------------"
 echo "USER          PID %CPU %MEM   SZ  RSS    TTY STAT    STIME  TIME  COMMAND"
 ps auxwww | egrep "mqm" | egrep "xml" | egrep -v "grep|amq|runmq|defunct" 

}
#-----------------------------------------------------------#
# ETC Resource                                              #
#-----------------------------------------------------------#
ETC_CHECK()
{
 #CPU/Memory Usage
 CPU_TOTAL=0
 MEM_TOTAL=0
 SZ_TOTAL=0
 ETC_CNT=0
 
 RESOURCES=`ps auxwww | grep mqm | egrep -v "grep|amq|runmq|xml|defunct" | awk '{print $3 "-" $4 "-" $5}'`
 for RESOURCE in $RESOURCES
 do
   CPU=`echo $RESOURCE | awk -F"-" '{print $1}'`
   MEM=`echo $RESOURCE | awk -F"-" '{print $2}'`
   SZ=`echo $RESOURCE | awk -F"-" '{print $3}'`

   CPU_TOTAL=`echo $CPU_TOTAL $CPU | awk '{printf "%.2f", $1 + $2}'`
   MEM_TOTAL=`echo $MEM_TOTAL $MEM | awk '{printf "%.2f", $1 + $2}'`
   SZ_TOTAL=`expr $SZ_TOTAL + $SZ`
   ETC_CNT=`expr $ETC_CNT + 1`
 done   
 
 echo "------------------------------------------------------------------------------------"
 echo " ETC Resource Check                                                                 " 
 echo " CPU(%)  : $CPU_TOTAL                                                               "
 echo " MEM(%)  : $MEM_TOTAL                                                               " 
 echo " MEM(Kb) : $SZ_TOTAL Kbyte                                                          "
 echo " Count   : $ETC_CNT                                                                 "
 echo "------------------------------------------------------------------------------------"
 echo "USER          PID %CPU %MEM   SZ  RSS    TTY STAT    STIME  TIME  COMMAND"
 ps auxwww | grep mqm | egrep -v "grep|amq|runmq|xml|defunct" 
}

while true
do
 clear
 DATE=`date +"%y-%m-%d %H:%M:%S"`

 echo "------------------------------------------------------------------------------------" 
 echo " System Resource Check ( mqm user )                                                 "
 echo " Date : $DATE                                                                       "
 echo "------------------------------------------------------------------------------------"  
 
 QMGR_CHECK
 BROKER_CHECK
 ETC_CHECK

sleep 5;
done
