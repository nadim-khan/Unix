
#!/bin/bash

clear

### Intialization ###

POD_DIR=/home/m69642/podium
HOST_DIR=host_lists
HOME_DIR=/home/m69642/RPSScripts/validation
TEMP_FILE=$HOME_DIR/Hosttempfile_`date +"%m%d%Y"`


##### Intializing Required Temp Files #####

LIST=$HOME_DIR/List.txt
SERVER_LIST=$HOME_DIR/Server.txt
> $LIST
> $SERVER_LIST

##### End Of Intialization #####

#### Reading the Argument Passed ####
APP="$1"
FILE="$2"

#### Check if the Argument is passed or not ####
if [[ $# -eq 0 ]] ; then
    echo "No arguments supplied. Please provide a valid Application name and POD name. E.g: ./defaultGatewayCheck.sh opus alp-pod-10"
        echo "The POD name exist at $POD_DIR"
        echo "Exiting from the script"
        echo "";echo ""
        echo "Script Execution FAILED"
        echo "";echo ""
    exit 1
fi

cd $POD_DIR

#### Reading the Host File ###
if [ -d "$APP" ];
then
           echo "$APP Located"
           cd $APP

        if [ -d "$FILE" ];
        then
                   echo "$FILE Located"

                  if [ -d $POD_DIR/$APP/$FILE/$HOST_DIR ];
                  then
                        echo "Extracting Host list from $HOST_DIR"
                        cd $POD_DIR/$APP/$FILE/$HOST_DIR

                        ######## Extracting VTIER from Host list #################

                        find . -type f -exec cat {} \;|grep vci.att.com| cut -d '@' -f 1 >>  $LIST

                        find . -type f -exec cat {} \;|grep vci.att.com| cut -d '@' -f2|cut -d '\' -f1 >>  $SERVER_LIST

                        ######## Displaying Server Details ###########

#                        for i in $(cat $LIST)
#                        do
#                                echo "$i"
#                        done

#                        for i in $(cat $SERVER_LIST)
#                       do
#                                echo "$i"
#                        done
                        #############################################

                  else
                        echo "$HOST_DIR does not exist in $FILE."
                                echo "Exiting from the script"
                        exit 1
                  fi

        else
                   echo "$FILE does not exist. Please provide a valid POD name. e.g.: alp-pod-10"
                           echo "Exiting from the script. "
                   exit 1
        fi

else
                   echo "$APP does not exist. Please provide a valid Application name. e.g.: opus"
                           echo "Exiting from the script. "
                   exit 1
fi


APPLICAION="$APP"
POD="$FILE"
SERVER_LIST=$SERVER_LIST
USER=$LIST

##### Generating Default Gateway Check Report ######

SENDMAIL="/usr/sbin/sendmail -t";
MAIL_FROM="From: nk815q@att.com"
#MAIL_TO="To:pm228x@att.com, mm726s@att.com"
MAIL_TO="To:nk815q@att.com"
MAIL_SUBJECT="Subject: Host_Vtier Mapping for  - $APPLICAION : $POD"

echo "MIME-Version: 1.0" >>$TEMP_FILE
echo $MAIL_FROM >> $TEMP_FILE
echo $MAIL_TO >> $TEMP_FILE
echo $MAIL_SUBJECT >> $TEMP_FILE
echo "Content-Type: text/html " >> $TEMP_FILE

echo "<html><head> " >> $TEMP_FILE
echo "<style type="text/css">" >> $TEMP_FILE
echo ".tab {width:350px ;font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 12px; border: 1px solid #000000;}" >> $TEMP_FILE
echo ".tab1 {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 12px; border: 1px solid #000000;width:150px ;}" >> $TEMP_FILE
echo "</style></head><body>" >> $TEMP_FILE
echo "<table><tr><th class="tab1">Server</th><th class="tab">Host</th></tr>" >> $TEMP_FILE

##### Checking the Default Gateway and IP ADDRESS #####

echo "Checking Hosts for $POD"
for server in `cat $USER`
do
        Host=`sshcmd -u ${server} -s ${server} "hostname "|tr ' ' '\t'|tail -1`
        #cd /usr/sbin
        #IP=`nslookup $server | tail -2 | head -1 | cut -f2 -d ":"`
        echo "<tr><td class="tab1">$server</td><td class="tab">$Host</td></tr>" >> $TEMP_FILE
done
echo "</table></body></html>" >> $TEMP_FILE
##### Sending Mail Report #####

echo "Check Complete dispatching the report to $MAIL_TO"
cat $TEMP_FILE | $SENDMAIL

#### Removing Temp File ####
rm $TEMP_FILE $LIST $SERVER_LIST

echo ""
echo "Script Complete Have a nice Day!!"
################## End Of Script ##################