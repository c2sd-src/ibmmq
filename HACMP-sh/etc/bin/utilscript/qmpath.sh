#!/bin/ksh

NAME_TO_FIND=$1

cat /var/mqm/mqs.ini | grep -v "^[ 	]*#" | \
  awk -F= -v name_to_find=$NAME_TO_FIND  \
  ' BEGIN {
      in_qmstanza="no";
      correct_stanza="no";
      name="not set";
      prefix="not set";
      directory="not set";
      datapath="not set";
    }
  # body
  {
    if (in_qmstanza=="no" && $1=="QueueManager:")
    {
      in_qmstanza="yes";
    }
    else if (in_qmstanza=="yes")
    {
      if ($1=="   Name")
      {
        #print "found name "$2
        name=$2;
      }
      if ($1=="   Prefix")
      {
        #print "found prefix "$2
        prefix=$2;
      }
      if ($1=="   Directory")
      {
        #print "found directory "$2
        directory=$2;
      }
      if ($1=="   DataPath")
      {
        #print "found DataPath "$2
        datapath=$2;
      }
      if ( match($1,"[.]*:$") )   # start of a stanza
      {
        if (name==name_to_find)
        {
          if (datapath!="not set")
          {
           result=sprintf("%s",datapath);
          }
          else
          {
            result=sprintf("%s/qmgrs/%s",
            prefix,directory);
            #print "result set to "result
          }
        }
        if ($1=="QueueManager:")
        {
          in_qmstanza="yes";
          name="not set";
          prefix="not set";
          directory="not set";
          datapath="not set";
        }
        else
        {
          in_qmstanza="no";
          name="not set";
          prefix="not set";
          directory="not set";
          datapath="not set";
        }
      }
    }
  }
  END {
    if (in_qmstanza=="yes")
    {
      if (name==name_to_find)
      {
        if (datapath!="not set")
        {
          result=sprintf("%s",datapath);
          #print "result set to "result
        }
        else
        {
          sprintf("%s/qmgrs/%s",prefix,directory);
          #print "result set to "result
        }
      }
    }
    if (result!="not set")
    {
      print result;
    }
    else
    {
      print "not found";
    }
  }
  '
