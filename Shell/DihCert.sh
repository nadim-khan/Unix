#!/bin/bash

POD_DIR=/opt/app/opusshare/Podium/PODs
HOST_DIR=host_lists
HOME_DIR=/home/m69642/RPSScripts/TEAM/nk815q
TEMP_FILE=$HOME_DIR/Host_Vtier_`date +"%m%d%Y"`.csv
LIST=$HOME_DIR/List.txt
> $LIST
> $TEMP_FILE
echo "VTier","SERVER_NAME","AJP STATUS","REMARKS" >>$TEMP_FILE

###Extraction###
        cd $POD_DIR
        for pod in `cat /home/m69642/RPSScripts/ajpcheck.txt`
        do
                cd $POD_DIR/$pod
                echo $pod >> $TEMP_FILE
                cd $pod/$HOST_DIR
                >$LIST
                find . -type f -exec cat {} \;|grep vci.att.com| cut -d '@' -f 1 >>  $LIST
                for server in `cat $LIST`
                do
                        SERVER=`/usr/sbin/nslookup $server|head -5|tail -1|tr -s "" " "|cut -d "=" -f2`
                        VAL=`sshaccess|grep $server`
                        if [[ $VAL != "" ]]
                        then
                                echo $server,$SERVER,"AJP Available",$VAL >> $TEMP_FILE
                        else
                                echo $server,$SERVER,"NOT SET" >> $TEMP_FILE
                        fi
                done
        done

### Sending Mail ###


uuencode $TEMP_FILE $TEMP_FILE|mailx -s "AJP Check from `hostname`" nk815q@att.com
echo "mail sent"

################################## End of script ###################################
