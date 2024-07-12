#!/usr/bin/ksh

### Logging
Today=`expr $(date +%y%m%d)`
LogFile=/eai2/log/SMEAI2D/resetChl_${Today}.log

### Qmgr Information
Qmgr=SMEAI2D
Status=RETRYING
GrepWord=CM

### Channel List
RetryChlList=`echo "DIS CHS(*) WHERE(STATUS EQ ${Status})" | runmqsc ${Qmgr} | grep CHANNEL | grep ${GrepWord} | sed 's/CHLTYPE(SDR)//g' | sed 's/ //g'`


echo "--------------------" `date +"%y/%m/%d %H:%M:%S"` "--------------------" >> ${LogFile}

if [ -z "${RetryChlList}" ]; then
        echo "There is no channel of "${Status}" state."                >> ${LogFile}
        echo                                                            >> ${LogFile}
        break;

else

        for i in ${RetryChlList}
        do
                Now=`date +"%y/%m/%d %H:%M:%S"`
                ChannelName=`echo $i | sed 's/CHANNEL(//g' | sed 's/)//g'`

                echo "["${Now}"] ["${ChannelName}"]"                                                >> ${LogFile}
                echo "STOP CHL(${ChannelName})"                    | runmqsc ${Qmgr} | grep AMQ     >> ${LogFile}
                echo "RESOLVE CHL(${ChannelName}) ACTION(BACKOUT)" | runmqsc ${Qmgr} | grep AMQ     >> ${LogFile}
                echo "RESET CHL(${ChannelName}) SEQNUM(1)"         | runmqsc ${Qmgr} | grep AMQ     >> ${LogFile}
                echo "START CHL(${ChannelName})"                   | runmqsc ${Qmgr} | grep AMQ     >> ${LogFile}
                echo                                                                                >> ${LogFile}
        done
fi

exit 0;

