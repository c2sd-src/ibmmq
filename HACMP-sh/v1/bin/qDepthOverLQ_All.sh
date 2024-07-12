#!/bin/ksh

rm -f /MQHA/bin/GW31_DEPTH_OVER_LIST.log
rm -f /MQHA/bin/GW32_DEPTH_OVER_LIST.log
rm -f /MQHA/bin/GW33_DEPTH_OVER_LIST.log
rm -f /MQHA/bin/GW34_DEPTH_OVER_LIST.log
rm -f /MQHA/bin/GW35_DEPTH_OVER_LIST.log
rm -f /MQHA/bin/GW36_DEPTH_OVER_LIST.log
rm -f /MQHA/bin/GW37_DEPTH_OVER_LIST.log
rm -f /MQHA/bin/GW38_DEPTH_OVER_LIST.log
rm -f /MQHA/bin/GW39_DEPTH_OVER_LIST.log
rm -f /MQHA/bin/GW40_DEPTH_OVER_LIST.log

echo 'use 'GW31'
list q
exit ' | /mqm/data/mi/ilink/ILinkCon 127.0.0.1 9998 | grep -v '(    0)' | grep LOCAL | grep LQ  | sed 's/LOCAL_PERSISTENT/ /g' | sed 's/ //g' | sed 's/.LQ(/     /g' | sed 's/)//g' | sed 's/TO.//g'  | awk '$2 > 10 {print $1}' | sed 's/1D/ 1ȣ��/g' | sed 's/2D/ 2ȣ��/g' | sed 's/3D/ 3ȣ��/g' | sed 's/4D/ 4ȣ��/g' | sed 's/5D/ 5ȣ��/g' | sed 's/6D/ 6ȣ��/g' | sed 's/7D/ 7ȣ��/g' | sed 's/8D/ 8ȣ��/g' | sed 's/9D/ 9ȣ��/g' >> /MQHA/bin/GW31_DEPTH_OVER_LIST.log

echo 'use 'GW32'
list q
exit ' | /mqm/data/mi/ilink/ILinkCon 127.0.0.1 9998 | grep -v '(    0)' | grep LOCAL | grep LQ  | sed 's/LOCAL_PERSISTENT/ /g' | sed 's/ //g' | sed 's/.LQ(/     /g' | sed 's/)//g' | sed 's/TO.//g'  | awk '$2 > 8000 {print $1}' | sed 's/1D/ 1ȣ��/g' | sed 's/2D/ 2ȣ��/g' | sed 's/3D/ 3ȣ��/g' | sed 's/4D/ 4ȣ��/g' | sed 's/5D/ 5ȣ��/g' | sed 's/6D/ 6ȣ��/g' | sed 's/7D/ 7ȣ��/g' | sed 's/8D/ 8ȣ��/g' | sed 's/9D/ 9ȣ��/g' >> /MQHA/bin/GW32_DEPTH_OVER_LIST.log

echo 'use 'GW33'
list q
exit ' | /mqm/data/mi/ilink/ILinkCon 127.0.0.1 9998 | grep -v '(    0)' | grep LOCAL | grep LQ  | sed 's/LOCAL_PERSISTENT/ /g' | sed 's/ //g' | sed 's/.LQ(/     /g' | sed 's/)//g' | sed 's/TO.//g'  | awk '$2 > 8000 {print $1}' | sed 's/1D/ 1ȣ��/g' | sed 's/2D/ 2ȣ��/g' | sed 's/3D/ 3ȣ��/g' | sed 's/4D/ 4ȣ��/g' | sed 's/5D/ 5ȣ��/g' | sed 's/6D/ 6ȣ��/g' | sed 's/7D/ 7ȣ��/g' | sed 's/8D/ 8ȣ��/g' | sed 's/9D/ 9ȣ��/g' >> /MQHA/bin/GW33_DEPTH_OVER_LIST.log

echo 'use 'GW34'
list q
exit ' | /mqm/data/mi/ilink/ILinkCon 127.0.0.1 9998 | grep -v '(    0)' | grep LOCAL | grep LQ  | sed 's/LOCAL_PERSISTENT/ /g' | sed 's/ //g' | sed 's/.LQ(/     /g' | sed 's/)//g' | sed 's/TO.//g'  | awk '$2 > 8000 {print $1}' | sed 's/1D/ 1ȣ��/g' | sed 's/2D/ 2ȣ��/g' | sed 's/3D/ 3ȣ��/g' | sed 's/4D/ 4ȣ��/g' | sed 's/5D/ 5ȣ��/g' | sed 's/6D/ 6ȣ��/g' | sed 's/7D/ 7ȣ��/g' | sed 's/8D/ 8ȣ��/g' | sed 's/9D/ 9ȣ��/g' >> /MQHA/bin/GW34_DEPTH_OVER_LIST.log

echo 'use 'GW35'
list q
exit ' | /mqm/data/mi/ilink/ILinkCon 127.0.0.1 9998 | grep -v '(    0)' | grep LOCAL | grep LQ  | sed 's/LOCAL_PERSISTENT/ /g' | sed 's/ //g' | sed 's/.LQ(/     /g' | sed 's/)//g' | sed 's/TO.//g'  | awk '$2 > 8000 {print $1}' | sed 's/1D/ 1ȣ��/g' | sed 's/2D/ 2ȣ��/g' | sed 's/3D/ 3ȣ��/g' | sed 's/4D/ 4ȣ��/g' | sed 's/5D/ 5ȣ��/g' | sed 's/6D/ 6ȣ��/g' | sed 's/7D/ 7ȣ��/g' | sed 's/8D/ 8ȣ��/g' | sed 's/9D/ 9ȣ��/g' >> /MQHA/bin/GW35_DEPTH_OVER_LIST.log

echo 'use 'GW36'
list q
exit ' | /mqm/data/mi/ilink/ILinkCon 127.0.0.1 9998 | grep -v '(    0)' | grep LOCAL | grep LQ  | sed 's/LOCAL_PERSISTENT/ /g' | sed 's/ //g' | sed 's/.LQ(/     /g' | sed 's/)//g' | sed 's/TO.//g'  | awk '$2 > 8000 {print $1}' | sed 's/1D/ 1ȣ��/g' | sed 's/2D/ 2ȣ��/g' | sed 's/3D/ 3ȣ��/g' | sed 's/4D/ 4ȣ��/g' | sed 's/5D/ 5ȣ��/g' | sed 's/6D/ 6ȣ��/g' | sed 's/7D/ 7ȣ��/g' | sed 's/8D/ 8ȣ��/g' | sed 's/9D/ 9ȣ��/g' >> /MQHA/bin/GW36_DEPTH_OVER_LIST.log

echo 'use 'GW37'
list q
exit ' | /mqm/data/mi/ilink/ILinkCon 127.0.0.1 9998 | grep -v '(    0)' | grep LOCAL | grep LQ  | sed 's/LOCAL_PERSISTENT/ /g' | sed 's/ //g' | sed 's/.LQ(/     /g' | sed 's/)//g' | sed 's/TO.//g'  | awk '$2 > 8000 {print $1}' | sed 's/1D/ 1ȣ��/g' | sed 's/2D/ 2ȣ��/g' | sed 's/3D/ 3ȣ��/g' | sed 's/4D/ 4ȣ��/g' | sed 's/5D/ 5ȣ��/g' | sed 's/6D/ 6ȣ��/g' | sed 's/7D/ 7ȣ��/g' | sed 's/8D/ 8ȣ��/g' | sed 's/9D/ 9ȣ��/g' >> /MQHA/bin/GW37_DEPTH_OVER_LIST.log

echo 'use 'GW38'
list q
exit ' | /mqm/data/mi/ilink/ILinkCon 127.0.0.1 9998 | grep -v '(    0)' | grep LOCAL | grep LQ  | sed 's/LOCAL_PERSISTENT/ /g' | sed 's/ //g' | sed 's/.LQ(/     /g' | sed 's/)//g' | sed 's/TO.//g'  | awk '$2 > 8000 {print $1}' | sed 's/1D/ 1ȣ��/g' | sed 's/2D/ 2ȣ��/g' | sed 's/3D/ 3ȣ��/g' | sed 's/4D/ 4ȣ��/g' | sed 's/5D/ 5ȣ��/g' | sed 's/6D/ 6ȣ��/g' | sed 's/7D/ 7ȣ��/g' | sed 's/8D/ 8ȣ��/g' | sed 's/9D/ 9ȣ��/g' >> /MQHA/bin/GW38_DEPTH_OVER_LIST.log

echo 'use 'GW39'
list q
exit ' | /mqm/data/mi/ilink/ILinkCon 127.0.0.1 9998 | grep -v '(    0)' | grep LOCAL | grep LQ  | sed 's/LOCAL_PERSISTENT/ /g' | sed 's/ //g' | sed 's/.LQ(/     /g' | sed 's/)//g' | sed 's/TO.//g'  | awk '$2 > 8000 {print $1}' | sed 's/1D/ 1ȣ��/g' | sed 's/2D/ 2ȣ��/g' | sed 's/3D/ 3ȣ��/g' | sed 's/4D/ 4ȣ��/g' | sed 's/5D/ 5ȣ��/g' | sed 's/6D/ 6ȣ��/g' | sed 's/7D/ 7ȣ��/g' | sed 's/8D/ 8ȣ��/g' | sed 's/9D/ 9ȣ��/g' >> /MQHA/bin/GW39_DEPTH_OVER_LIST.log

echo 'use 'GW40'
list q
exit ' | /mqm/data/mi/ilink/ILinkCon 127.0.0.1 9998 | grep -v '(    0)' | grep LOCAL | grep LQ  | sed 's/LOCAL_PERSISTENT/ /g' | sed 's/ //g' | sed 's/.LQ(/     /g' | sed 's/)//g' | sed 's/TO.//g'  | awk '$2 > 8000 {print $1}' | sed 's/1D/ 1ȣ��/g' | sed 's/2D/ 2ȣ��/g' | sed 's/3D/ 3ȣ��/g' | sed 's/4D/ 4ȣ��/g' | sed 's/5D/ 5ȣ��/g' | sed 's/6D/ 6ȣ��/g' | sed 's/7D/ 7ȣ��/g' | sed 's/8D/ 8ȣ��/g' | sed 's/9D/ 9ȣ��/g' >> /MQHA/bin/GW40_DEPTH_OVER_LIST.log


